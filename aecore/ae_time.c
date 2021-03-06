/* -----------------------------------------------------------------------------
--- Copyright (c) 2012-2017 Adam Schackart / "AJ Hackman", all rights reserved.
--- Distributed under the BSD license v2 (opensource.org/licenses/BSD-3-Clause)
--------------------------------------------------------------------------------
--- TODO: void ae_sleep(double seconds); will actually be tough to implement!!!
--- TODO: ae_datetime: fill struct with ints - year, month, day, hour, min, sec
--- TODO: ae_current_united_states_holiday and ae_current_international_holiday
--------------------------------------------------------------------------------
--- TODO: benchmark function that prints the name of the function passed to it,
--- as well as inner and outer loop counts (times are printed in the outer loop).
--- it should also track and display min and max times etc. like the profiler.
----------------------------------------------------------------------------- */
#ifndef __AE_CORE_H__
#include <ae_core.h>
#endif

/*
================================================================================
 * ~~ [ timer ] ~~ *
--------------------------------------------------------------------------------
*/

#if defined(_WIN32)

// this differs from ae_seconds in that it doesn't require init, and fails gracefully
double ae_internal_seconds(void)
{
    LARGE_INTEGER freq, perf;

    if (QueryPerformanceFrequency(&freq) && QueryPerformanceCounter(&perf))
    {
        return (double)perf.QuadPart / (double)freq.QuadPart;
    }
    else
    {
        return 0.0;
    }
}

static LARGE_INTEGER ae_performance_frequency;
static LARGE_INTEGER ae_initial_perf_counter;

double ae_seconds(void)
{
    // by this point, we've cached all possible system information (for maximum perf)
    LARGE_INTEGER performance_counter;

    ae_assert( ae_performance_frequency.QuadPart, "call ae_init before ae_seconds!");
    QueryPerformanceCounter(&performance_counter);

    return (double)(performance_counter.QuadPart - ae_initial_perf_counter.QuadPart) \
                                        / (double)ae_performance_frequency.QuadPart;
}

static void ae_time_counter_init(int argc, char** argv)
{
    if (!QueryPerformanceFrequency( &ae_performance_frequency ))
        ae_error("failed to query system performance frequency");

    if( !QueryPerformanceCounter( &ae_initial_perf_counter ) )
        ae_error("failed to query system performance counter");

    ae_log(TIME, "performance frequency is %u counts per second",
                        (u32)ae_performance_frequency.QuadPart);
}

static void ae_time_counter_quit(void) {}

#elif defined(__APPLE__)

// TODO: github.com/ThomasHabets/monotonic_clock/blob/master/src/monotonic_mach.c
#error TODO high-precision timer using mach_timebase_info and mach_absolute_time

#elif defined(unix) || defined(__unix__) || defined(__unix)

/*
XXX This may not be available on older systems (it's part of the
    POSIX 2008 standard) or non-GNU standard builds (-std=cXXX).
*/
#if defined(CLOCK_MONOTONIC_RAW)
    #define AE_MONOTONIC_CLOCK CLOCK_MONOTONIC_RAW
#else
    #define AE_MONOTONIC_CLOCK CLOCK_MONOTONIC
#endif

double ae_internal_seconds(void)
{
    struct timespec ts; // safer for timing init

    memset(&ts, 0, sizeof(ts)); // zero out
    clock_gettime(AE_MONOTONIC_CLOCK, &ts);

    return ts.tv_sec + ts.tv_nsec / 1000000000.0;
}

double ae_seconds(void)
{
    struct timespec ts; // TODO: gettimeofday fallback?
    clock_gettime(AE_MONOTONIC_CLOCK, &ts);

    // TODO: offset by the initial time (like in win32)
    return ts.tv_sec + ts.tv_nsec / 1000000000.0;
}

static void ae_time_counter_init(int argc, char** argv)
{
    struct timespec time_spec;

    if (clock_gettime(AE_MONOTONIC_CLOCK, &time_spec))
        ae_error("failed to create a monotonic timer");
}

static void ae_time_counter_quit(void) {}

#else

static void ae_time_counter_init(int argc, char** argv) {}
static void ae_time_counter_quit(void) {}

double ae_seconds(void) { AE_STUB(); return 0.0; }
double ae_internal_seconds(void) { return 0.0; }

#endif

/* ===== [ frame timer ] ==================================================== */

typedef struct ae_frame_callback_data_t
{
    char name[128];
    ae_frame_callback_t function;
    void * context;
} \
    ae_frame_callback_data_t;

static void ae_frame_callback_init(int argc, char** argv) {}
static ae_frame_callback_data_t ae_frame_callbacks[ 128 ];

static void ae_frame_callback_quit(void)
{
    memset(ae_frame_callbacks, 0, sizeof(ae_frame_callbacks));
}

static void
ae_frame_callback_unregister_ex(const char* name, size_t index)
{
    for (; index < AE_ARRAY_COUNT(ae_frame_callbacks); index++)
    {
        ae_frame_callback_data_t* data = ae_frame_callbacks + index;

        if (!strncmp(data->name, name, sizeof(data->name) - 1))
        {
            #if defined(AE_TIME_TRACE)
            ae_log(TIME, "unregistered frame callback \"%s\"", name);
            #endif

            data->name[0] = '\0';
            data->function = NULL;
            data->context = NULL;

            return;  // found our slot, no need to keep iterating
        }
    }

    AE_WARN("failed to unregister frame callback \"%s\"!", name);
}

static void ae_frame_callback_update(double dt)
{
    AE_PROFILE_ENTER(); // track the time we spend in callbacks

    size_t i = 0, n = AE_ARRAY_COUNT(ae_frame_callbacks);
    for (; i < n; i++)
    {
        ae_frame_callback_data_t* data = ae_frame_callbacks + i;

        ae_if (data->function != NULL)
        {
            data->function(data->name, dt, data->context);
        }
    }

    AE_PROFILE_LEAVE();
}

void
ae_frame_callback_register(const char* name, ae_frame_callback_t func, void* ctx)
{
    size_t i = 0, n = AE_ARRAY_COUNT(ae_frame_callbacks); // O(n)

    // TODO: NULL function pointer should unregister the callback!
    ae_assert(func != NULL, "NULL frame callback \"%s\"", name);

    for (; i < n; i++)
    {
        ae_frame_callback_data_t* data = ae_frame_callbacks + i;

        if (!strncmp(data->name, name, sizeof(data->name) - 1))
        {
            ae_frame_callback_unregister_ex(name, i);
        }

        if (data->function == NULL)
        {
            #if defined(AE_TIME_TRACE)
            ae_log(TIME, "registered frame callback \"%s\"", name);
            #endif

            ae_strncpy(data->name, name, sizeof(data->name) - 1);
            data->function = func;
            data->context = ctx;

            return;  // found our slot, no need to keep iterating
        }
    }

    ae_error("failed to register frame callback \"%s\"!", name);
}

void ae_frame_callback_unregister(const char* name)
{
    ae_frame_callback_unregister_ex(name, 0);
}

int
ae_frame_callback_get(const char* name, ae_frame_callback_t* func, void** ctx)
{
    size_t i = 0, n = AE_ARRAY_COUNT(ae_frame_callbacks); // O(n)

    if (func) *func = NULL;
    if (ctx ) *ctx  = NULL;

    for (; i < n; i++)
    {
        ae_frame_callback_data_t* data = ae_frame_callbacks + i;

        if (!strncmp(data->name, name, sizeof(data->name) - 1))
        {
            if (func) *func = data->function;
            if (ctx ) *ctx  = data->context;

            return 1;  // found our slot, no need to keep iterating
        }
    }

    return 0;
}

// TODO: keep a separate hashtable (name -> index) to avoid O(n) timer queries!!!
// ae_(frame/timer)_callback_get should use a get_ex() that checks the hashtable,
// as well as unregister. could we repurpose our block allocator code to register
// timers in O(1), storing our index as the block's offset from the chunk start?

typedef struct ae_timer_callback_data_t
{
    char name[128];
    ae_timer_callback_t function;
    void * context;

    double current;
    double seconds;

    int repeat;
} \
    ae_timer_callback_data_t;

static void ae_timer_callback_init(int argc, char** argv) {}
static ae_timer_callback_data_t ae_timer_callbacks[ 128 ];

static void ae_timer_callback_quit(void)
{
    memset(ae_timer_callbacks, 0, sizeof(ae_timer_callbacks));
}

static void
ae_timer_callback_unregister_ex(const char* name, size_t index)
{
    for (; index < AE_ARRAY_COUNT(ae_timer_callbacks); index++)
    {
        ae_timer_callback_data_t* data = ae_timer_callbacks + index;

        if (!strncmp(data->name, name, sizeof(data->name) - 1))
        {
            #if defined(AE_TIME_TRACE)
            ae_log(TIME, "unregistered timer callback \"%s\"", name);
            #endif

            data->name[0] = '\0';
            data->function = NULL;
            data->context = NULL;
            data->current = 0.0;
            data->seconds = 0.0;
            data->repeat = 0;

            return; // found our slot, no need to keep iterating
        }
    }

    AE_WARN("failed to unregister timer callback \"%s\"!", name);
}

static void ae_timer_callback_update(double dt)
{
    AE_PROFILE_ENTER(); // track the time we spend in callbacks

    size_t i = 0, n = AE_ARRAY_COUNT(ae_timer_callbacks);
    for (; i < n; i++)
    {
        ae_timer_callback_data_t* data = ae_timer_callbacks + i;

        ae_if (data->function != NULL)
        {
            data->current += dt;

            ae_if (data->current >= data->seconds) // timer fired - wrap or unregister
            {
                data->function(data->name, data->current, data->repeat, data->context);

                ae_if (data->repeat)
                {
                    data->current -= data->seconds;
                    data->repeat++;
                }
                else
                {
                    ae_timer_callback_unregister_ex(data->name, i);
                }
            }
        }
    }

    AE_PROFILE_LEAVE();
}

void ae_timer_callback_register(const char* name, ae_timer_callback_t func,
                                double seconds, int repeat, void* context)
{
    size_t i = 0, n = AE_ARRAY_COUNT(ae_timer_callbacks); // O(n)

    // TODO: NULL function pointer should unregister the callback!
    ae_assert(func != NULL, "NULL timer callback \"%s\"", name);

    for (; i < n; i++)
    {
        ae_timer_callback_data_t* data = ae_timer_callbacks + i;

        if (!strncmp(data->name, name, sizeof(data->name) - 1))
        {
            ae_timer_callback_unregister_ex(name, i);
        }

        if (data->function == NULL)
        {
            #if defined(AE_TIME_TRACE)
            ae_log(TIME, "registered timer callback \"%s\"", name);
            #endif

            ae_strncpy(data->name, name, sizeof(data->name) - 1);
            data->function = func;
            data->context = context;
            data->current = 0.0;
            data->seconds = seconds;
            data->repeat = repeat;

            return; // found our slot, no need to keep iterating
        }
    }

    ae_error("failed to register timer callback \"%s\"!", name);
}

void ae_timer_callback_unregister(const char* name)
{
    ae_timer_callback_unregister_ex(name, 0);
}

int ae_timer_callback_get( const char* name, ae_timer_callback_t* function,
            double* current, double* seconds, int* repeat, void** context)
{
    size_t i = 0, n = AE_ARRAY_COUNT(ae_timer_callbacks); // O(n)

    if (function) *function = NULL;
    if (current) *current = 0.0;
    if (seconds) *seconds = 0.0;
    if (repeat) *repeat = 0;
    if (context) *context = NULL;

    for (; i < n; i++)
    {
        ae_timer_callback_data_t* data = ae_timer_callbacks + i;

        if (!strncmp(data->name, name, sizeof(data->name) - 1))
        {
            if (function) *function = data->function;
            if (current) *current = data->current;
            if (seconds) *seconds = data->seconds;
            if (repeat) *repeat = data->repeat;
            if (context) *context = data->context;

            return 1; // found our slot, no need to keep iterating
        }
    }

    return 0;
}

void ae_timer_callback_set_repeat(const char* name, int repeat)
{
    size_t i = 0, n = AE_ARRAY_COUNT(ae_timer_callbacks); // O(n)
    for (; i < n; i++)
    {
        ae_timer_callback_data_t* data = ae_timer_callbacks + i;

        if (!strncmp(data->name, name, sizeof(data->name) - 1))
        {
            data->repeat = repeat;
            return; // found our slot, no need to keep iterating
        }
    }

    AE_WARN("failed to set_repeat timer callback \"%s\"!", name);
}

static double ae_previous_frame_time;

double ae_frame_delta(void)
{
    const double current = ae_seconds(); // seconds elapsed
    const double delta_t = current - ae_previous_frame_time;

    ae_previous_frame_time = current;

    ae_timer_callback_update(delta_t);
    ae_frame_callback_update(delta_t);

    return delta_t;
}

/*
================================================================================
 * ~~ [ display & stringification ] ~~ *
--------------------------------------------------------------------------------
NOTE: displaying time with hours is for showing total gameplay time in a stats
menu ("elder scrolls" mode), and time without hours is for end-of-level reports
("goldeneye" mode for speedrunners). if you want days, roll your own function.
--------------------------------------------------------------------------------
*/

void ae_seconds_to_display(double t, int* hours, int* minutes, int* seconds)
{
    ae_if (hours != NULL)
    {
        *hours = 0;

        while (t >= 60.0 * 60.0)
        {
            t -= 60.0 * 60.0; *hours += 1;
        }
    }

    ae_if (minutes != NULL)
    {
        *minutes = 0;

        while (t >= 60.0)
        {
            t -= 60.0; *minutes += 1;
        }
    }

    ae_if (seconds != NULL)
    {
        *seconds = (int)floor(t);
    }
}

double ae_display_to_seconds(int hours, int minutes, int seconds)
{
    double t = 0.0;

    while (hours)
    {
        t += 60.0 * 60.0; hours--;
    }

    while (minutes)
    {
        t += 60.0; minutes--;
    }

    return t + (double)seconds;
}

const char* ae_seconds_to_string(double t, int show_hours)
{
    static char time_string[1024*1];
    int h, m, s, r;

    ae_if (show_hours)
    {
        ae_seconds_to_display(t, &h, &m, &s);
        r = AE_SNPRINTF(time_string, "%02ih:%02im:%02is", h, m, s);
    }
    else
    {
        ae_seconds_to_display(t, NULL, &m, &s);
        r = AE_SNPRINTF(time_string, "%02im:%02is", m, s);
    }

    if (r < 0)
    {
        AE_WARN("%u-byte buffer is not big enough for time string",
                                (unsigned int)sizeof(time_string));
        return "?";
    }

    return (const char*)time_string;
}

double ae_string_to_seconds(const char* string)
{
    AE_STUB(); return 0.0;
}

/*
================================================================================
 * ~~ [ profiler ] ~~ *
--------------------------------------------------------------------------------
TODO: each thread needs to have its own profiler (this isn't threadsafe at all)
TODO: could handle C++ overloading easier if we took line numbers (big change!)
TODO: track depths of functions in the profiler callstack (min, max, & average)
TODO: function to write total report (all categories) to a file in the home dir
TODO: "immediate mode" - print the function time immediately for benchmarks etc
--------------------------------------------------------------------------------
*/

#if defined(AE_PROFILE_ENABLE)

static ae_strmap_t ae_global_profile; // string function name -> profile node.
static ae_memory_chunk_t ae_profile_node_chunk; // profile node memory blocks.

typedef struct ae_profile_context_t
{
    // file and function names. these may or may not be dynamically allocated,
    // so to be safe we still allocate and copy them into a normal string map.
    const char* filename;
    const char* funcname;

    // used for computing the time delta taken up by the function's execution.
    double start_seconds;
} \
    ae_profile_context_t;

static void ae_profile_free_nodes(void)
{
    int i = 0;

    char* k;
    void* v;

    for ( ; i < ae_global_profile.limit ? // iterate profile
            k = ae_global_profile.table[i].key,
            v = ae_global_profile.table[i].val, 1 : 0; ++i )
    {
        if (k == NULL || k == (char*)1) {} else
        {
            ae_block_free(&ae_profile_node_chunk, v);
        }
    }
}

/* ===== [ public API ] ===================================================== */

void* ae_profile_enter(const char* filename, const char* funcname)
{
    /* NOTE we can always use the block allocator here if we encounter issues,
     * or make another stack just for the profiler so nothing else interferes.
     */
    ae_profile_context_t* context = (ae_profile_context_t*)
        ae_stack_malloc(ae_global_stack(), sizeof(ae_profile_context_t));

    /* TODO: Modern compilers can fold const expressions like strlen(__FILE__).
     * Use this in our macro to take a faster string hash and allocation path.
     * We also don't need to store these, we should take args in profile_leave.
     */
    context->filename = filename;
    context->funcname = funcname;

    /* TODO: should we call rdtsc after this? we have to measure its cost on
     * a bunch of different platforms to make sure it isn't altering results.
     */
    context->start_seconds = ae_seconds();

    return (void*)context;
}

void ae_profile_leave(void* _context)
{
    ae_profile_context_t * context = (ae_profile_context_t *)_context;
    double functime = ae_seconds() - context->start_seconds; // get dt

    char * funcname = (char *)context->funcname;
    char * filename = (char *)context->filename;

    // get func info if it's been called before, otherwise create a new node.
    u32 funchash = ae_hash_str(funcname);

    ae_profile_node_t* node = (ae_profile_node_t*)ae_strmap_get_ex(
                            &ae_global_profile, funcname, funchash);
    if (node == NULL)
    {
        // fringe case, but this will leak if the table has no implementation
        ae_assert(ae_global_profile.table, "hash table code is stubbed out");

        node = (ae_profile_node_t*)ae_block_malloc(&ae_profile_node_chunk);
        /*
         * NOTE: we could save time, memory, and a little safety here by just
         * assigning the strmap key (funcname) to a char* instead of copying.
         * however, we can safely copy and store nodes indefinitely this way.
         */
        ae_assert(strlen(funcname) < sizeof(node->funcname), "%s", funcname);
        AE_STRNCPY(node->funcname, funcname);

        ae_assert(strlen(filename) < sizeof(node->filename), "%s", filename);
        AE_STRNCPY(node->filename, filename);

        node->first_call = context->start_seconds;
        node->time_taken = 0;
        node->call_count = 0;

        node->min_time = functime;
        node->max_time = functime;

        if (!ae_strmap_add_ex(&ae_global_profile, funcname, node, funchash))
        {
            ae_error("failed to add profile node (is table code stubbed?");
        }
    }

    ae_assert(!strcmp(filename, node->filename), "file collision for func \"%s"
        "\": expected \"%s\", got \"%s\"", funcname, node->filename, filename);

    node->time_taken += functime;
    node->call_count += 1;

    if (functime < node->min_time) node->min_time = functime;
    if (functime > node->max_time) node->max_time = functime;

    ae_stack_free(ae_global_stack(), _context, sizeof(ae_profile_context_t));
}

int ae_profile_enabled(void)
{
    return 1;
}

void ae_profile_clear(void)
{
    ae_profile_free_nodes(); // reset profile

    ae_strmap_free(&ae_global_profile);
    ae_strmap_init(&ae_global_profile, 1024);
}

/* ===== [ rendering ] ====================================================== */

static int ae_profile_sort_total_time(const void* a, const void* b)
{
    const double a_time = (*(ae_profile_node_t**)a)->time_taken;
    const double b_time = (*(ae_profile_node_t**)b)->time_taken;

    if (a_time < b_time) return +1;
    if (a_time > b_time) return -1;

    return 0;
}

static int ae_profile_sort_average_time(const void* a, const void* b)
{
    const double a_time = (*(ae_profile_node_t**)a)->time_taken /
                ( double )(*(ae_profile_node_t**)a)->call_count;

    const double b_time = (*(ae_profile_node_t**)b)->time_taken /
                ( double )(*(ae_profile_node_t**)b)->call_count;

    if (a_time < b_time) return +1;
    if (a_time > b_time) return -1;

    return ae_profile_sort_total_time(a, b);
}

static int ae_profile_sort_call_count(const void* a, const void* b)
{
    const size_t a_call = (*(ae_profile_node_t**)a)->call_count;
    const size_t b_call = (*(ae_profile_node_t**)b)->call_count;

    if (a_call < b_call) return +1;
    if (a_call > b_call) return -1;

    return ae_profile_sort_total_time(a, b);
}

static int ae_profile_sort_funcname(const void* a, const void* b)
{
    const char* a_name = (*(ae_profile_node_t**)a)->funcname;
    const char* b_name = (*(ae_profile_node_t**)b)->funcname;

    return strcmp(a_name, b_name);
}

static int ae_profile_sort_filename(const void* a, const void* b)
{
    const char* a_name = (*(ae_profile_node_t**)a)->filename;
    const char* b_name = (*(ae_profile_node_t**)b)->filename;

    const int name_cmp = strcmp(a_name, b_name);

    if (name_cmp < 0) return -1;
    if (name_cmp > 0) return +1;

    return ae_profile_sort_funcname(a, b);
}

static int ae_profile_sort_first_call(const void* a, const void* b)
{
    const double a_time = (*(ae_profile_node_t**)a)->first_call;
    const double b_time = (*(ae_profile_node_t**)b)->first_call;

    if (a_time < b_time) return -1;
    if (a_time > b_time) return +1;

    // it shouldn't even be possible to call two functions at once
    assert(0); return 0;
}

static int ae_profile_sort_min_time(const void* a, const void* b)
{
    const double a_min = (*(ae_profile_node_t**)a)->min_time;
    const double b_min = (*(ae_profile_node_t**)b)->min_time;

    if (a_min > b_min) return -1;
    if (a_min < b_min) return +1;

    return ae_profile_sort_total_time(a, b); // TODO: average?
}

static int ae_profile_sort_max_time(const void* a, const void* b)
{
    const double a_max = (*(ae_profile_node_t**)a)->max_time;
    const double b_max = (*(ae_profile_node_t**)b)->max_time;

    if (a_max > b_max) return -1;
    if (a_max < b_max) return +1;

    return ae_profile_sort_total_time(a, b); // TODO: average?
}

static int ae_profile_sort_diff_time(const void* a, const void* b)
{
    const double a_min = (*(ae_profile_node_t**)a)->min_time;
    const double b_min = (*(ae_profile_node_t**)b)->min_time;

    const double a_max = (*(ae_profile_node_t**)a)->max_time;
    const double b_max = (*(ae_profile_node_t**)b)->max_time;

    const double a_diff = a_max - a_min;
    const double b_diff = b_max - b_min;

    if (a_diff > b_diff) return -1;
    if (a_diff < b_diff) return +1;

    return ae_profile_sort_total_time(a, b); // TODO: average?
}

void ae_profile_render(AE_PROFILE_RENDER_FUNC render, ae_profile_sort_t sort,
                        size_t max_items, double dt) // abstract sort & draw
{
    int (*compare)(const void*, const void*) = NULL;
    ae_profile_node_t** items;

    items = (ae_profile_node_t**)ae_stack_malloc(ae_global_stack(),
            ae_global_profile.count * sizeof(ae_profile_node_t *));
    {
        int i = 0, j = 0;

        char* k;
        void* v;

        for ( ; i < ae_global_profile.limit ? // iterate profile
                k = ae_global_profile.table[i].key,
                v = ae_global_profile.table[i].val, 1 : 0; ++i )
        {
            if (k == NULL || k == (char*)1) {} else
            {
                items[j++] = (ae_profile_node_t*)v;
            }
        }

        assert(ae_global_profile.count == j);
    }

    ae_switch (sort, ae_profile_sort, AE_PROFILE_SORT, suffix)
    {
        #define N(hi, lo)                                   \
                                                            \
            case AE_PROFILE_SORT_ ## hi: /* comparator */   \
                compare = ae_profile_sort_ ## lo; break;    \

        AE_PROFILE_SORT_N
        #undef N

        default: assert(0); break;
    }

    qsort(items, ae_global_profile.count, sizeof(ae_profile_node_t*), compare);
    {
        int i = 0; // iterate the sorted profile nodes and render them
        for (; i < ae_global_profile.count; i++)
        {
            // TODO: profile "render" func should take a context param
            if ((size_t)i == max_items) break; else render(items[i]);
        }
    }

    ae_stack_free(ae_global_stack(), items, ae_global_profile.count *
                                        sizeof(ae_profile_node_t *));
}

static void ae_profile_node_print(ae_profile_node_t* node)
{
    printf("%s\n\ttime %f, avg %f, min %f, max %f, diff %f,\n\tcalls %u, file \"%s\"\n",
            node->funcname,
            node->time_taken,
            node->time_taken / (double)node->call_count,
            node->min_time,
            node->max_time,
            node->max_time - node->min_time,
            (u32)node->call_count,
            node->filename);
}

void ae_profile_print(ae_profile_sort_t sort, size_t max_items, double dt)
{
    int i;

    for(i = 0; i < 80; ++i) printf("-"); printf("\n");

    printf("\t%s (dt %f, fps %f)\n", // show framerate
            ae_profile_sort_name[sort], dt, 1.0 / dt);

    for(i = 0; i < 80; ++i) printf("-"); printf("\n");

    ae_profile_render(ae_profile_node_print, sort, max_items, dt);
}

/* ===== [ initialization ] ================================================= */

static void ae_time_profile_init(int argc, char** argv)
{
    if (!ae_cpuinfo_rdtsc())
    {
        ae_error("processor doesn't support the timestamp counter instruction");
    }

    ae_chunk_create(&ae_profile_node_chunk, "profile_node",
                    sizeof(ae_profile_node_t), 1024 * 4);

    ae_profile_clear();
}

static void ae_time_profile_quit(void)
{
    ae_profile_free_nodes(); // free the nodes
    ae_strmap_free(&ae_global_profile);

    ae_chunk_destroy(&ae_profile_node_chunk);
}

#else

static void ae_time_profile_init(int argc, char** argv) {} // profile disabled
static void ae_time_profile_quit(void) {}

void* ae_profile_enter(const char* file_n, const char* func_n) { return NULL; }
void ae_profile_leave(void* ctx) {}

int ae_profile_enabled(void) { return 0; }
void ae_profile_clear(void) {}

void ae_profile_render(AE_PROFILE_RENDER_FUNC render, ae_profile_sort_t sort,
                                            size_t max_items, double dt) {}

void ae_profile_print(ae_profile_sort_t sort, size_t max_items, double dt) {}

#endif

/*
================================================================================
 * ~~ [ initialization ] ~~ *
--------------------------------------------------------------------------------
*/

void ae_time_init(int argc, char** argv)
{
    if (ae_log_is_enabled(AE_LOG_CATEGORY_TIME))
    {
        struct tm* time_info;
        time_t raw_time;
        char init_date[1024];

        time(&raw_time); // convert time into the proper format for strftime
        time_info = localtime(&raw_time);

        strftime(init_date, sizeof(init_date), "%b %d %Y at %X", time_info);
        if (init_date[4] == '0') init_date[4] = ' '; // HACK standin C89 %e

        ae_log(TIME, "aecore build date is %s at %s", __DATE__, __TIME__);
        ae_log(TIME, "aecore start date is %s", init_date); // build & init
    }

    ae_time_counter_init(argc, argv);
    ae_time_profile_init(argc, argv);

    /* prevent big first frame delta if ae_seconds begins with a large value.
     * this still doesn't prevent library initialization from spiking deltas.
     */
    ae_previous_frame_time = ae_seconds();

    ae_frame_callback_init(argc, argv);
    ae_timer_callback_init(argc, argv);
}

void ae_time_quit(void)
{
    if (ae_log_is_enabled(AE_LOG_CATEGORY_TIME))
    {
        struct tm* time_info;
        time_t raw_time;
        char quit_date[1024];

        time(&raw_time); // convert time into the proper format for strftime
        time_info = localtime(&raw_time);

        strftime(quit_date, sizeof(quit_date), "%b %d %Y at %X", time_info);
        if (quit_date[4] == '0') quit_date[4] = ' '; // HACK standin C89 %e

        ae_log(TIME, "aecore end date is %s", quit_date);
    }

    ae_timer_callback_quit();
    ae_frame_callback_quit();

    ae_time_profile_quit();
    ae_time_counter_quit();
}
