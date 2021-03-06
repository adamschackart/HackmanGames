# ------------------------------------------------------------------------------
# Copyright (c) 2012-2017 Adam Schackart / "AJ Hackman", all rights reserved.
# Distributed under the BSD license v2 (opensource.org/licenses/BSD-3-Clause)
# ------------------------------------------------------------------------------
# TODO: return button/key lists as sets where possible, as order doesn't matter
# TODO: should we use tuples for input history? performance is likely better...
# ------------------------------------------------------------------------------
from aegame.utl cimport *
from aegame.vec cimport *
from aegame.lin cimport *
from aegame.mem cimport *
from aegame.img cimport *
from aegame.exm cimport *

import sys # version info

cdef extern from "xl_core.h":
    # ==========================================================================
    # ~ [ macros & init ]
    # ==========================================================================

    int xl_is_init()

    void xl_init()
    void xl_quit()

    int xl_audio_is_init()

    void xl_audio_init()
    void xl_audio_quit()

    # make sure you're at the right house before breaking in through the backdoor
    const char* xl_implementation()
    const char* xl_audio_implementation()

    # ==========================================================================
    # ~ [ object types ]
    # ==========================================================================

    ctypedef void xl_window_t
    ctypedef void xl_controller_t
    ctypedef void xl_texture_t
    ctypedef void xl_font_t
    ctypedef void xl_sound_t
    ctypedef void xl_animation_t
    ctypedef void xl_keyboard_t
    ctypedef void xl_mouse_t
    ctypedef void xl_clock_t

    ctypedef enum xl_object_type_t:
        XL_OBJECT_TYPE_UNKNOWN
        XL_OBJECT_TYPE_WINDOW
        XL_OBJECT_TYPE_CONTROLLER
        XL_OBJECT_TYPE_TEXTURE
        XL_OBJECT_TYPE_FONT
        XL_OBJECT_TYPE_SOUND
        XL_OBJECT_TYPE_ANIMATION
        XL_OBJECT_TYPE_KEYBOARD
        XL_OBJECT_TYPE_MOUSE
        XL_OBJECT_TYPE_CLOCK
        XL_OBJECT_TYPE_COUNT

    xl_object_type_t xl_object_type(void *)

    const char* xl_object_type_name[]
    const char* xl_object_type_short_name[]

    size_t xl_object_count_all()
    void xl_object_list_all(void** objects)

    void xl_object_print_all()
    void xl_object_close_all()

    # ==========================================================================
    # ~ [ window management ]
    # ==========================================================================

    xl_window_t* xl_window_create(int initially_visible)
    xl_window_t* xl_primary_window()

    ctypedef enum xl_window_property_t:
        XL_WINDOW_PROPERTY_TOTAL
        XL_WINDOW_PROPERTY_ID
        XL_WINDOW_PROPERTY_TEXTURE_COUNT
        XL_WINDOW_PROPERTY_HIGH_QUALITY_TEXTURES
        XL_WINDOW_PROPERTY_COPY_TEXTURES
        XL_WINDOW_PROPERTY_FONT_COUNT
        XL_WINDOW_PROPERTY_X
        XL_WINDOW_PROPERTY_Y
        XL_WINDOW_PROPERTY_WIDTH
        XL_WINDOW_PROPERTY_HEIGHT
        XL_WINDOW_PROPERTY_DISPLAY_X
        XL_WINDOW_PROPERTY_DISPLAY_Y
        XL_WINDOW_PROPERTY_DISPLAY_WIDTH
        XL_WINDOW_PROPERTY_DISPLAY_HEIGHT
        XL_WINDOW_PROPERTY_RENDER_WIDTH
        XL_WINDOW_PROPERTY_RENDER_HEIGHT
        XL_WINDOW_PROPERTY_FULLSCREEN
        XL_WINDOW_PROPERTY_BORDERED
        XL_WINDOW_PROPERTY_VISIBLE
        XL_WINDOW_PROPERTY_RESIZABLE
        XL_WINDOW_PROPERTY_ACTIVE
        XL_WINDOW_PROPERTY_GRABBED
        XL_WINDOW_PROPERTY_OPENGL
        XL_WINDOW_PROPERTY_VSYNC
        XL_WINDOW_PROPERTY_PRIMARY
        XL_WINDOW_PROPERTY_OPEN
        XL_WINDOW_PROPERTY_STATUS
        XL_WINDOW_PROPERTY_TITLE
        XL_WINDOW_PROPERTY_NAME
        XL_WINDOW_PROPERTY_ICON
        XL_WINDOW_PROPERTY_OPACITY
        XL_WINDOW_PROPERTY_SDL_WINDOW
        XL_WINDOW_PROPERTY_SDL_RENDERER
        XL_WINDOW_PROPERTY_SDL_RENDERER_INFO
        XL_WINDOW_PROPERTY_SDL_GL_CONTEXT
        XL_WINDOW_PROPERTY_DRIVER
        XL_WINDOW_PROPERTY_NATIVE_DISPLAY
        XL_WINDOW_PROPERTY_NATIVE_WINDOW
        XL_WINDOW_PROPERTY_WIN32_WINDOW
        XL_WINDOW_PROPERTY_WIN32_HDC
        XL_WINDOW_PROPERTY_WIN32_HINSTANCE
        XL_WINDOW_PROPERTY_WINRT_WINDOW
        XL_WINDOW_PROPERTY_X11_DISPLAY
        XL_WINDOW_PROPERTY_X11_WINDOW
        XL_WINDOW_PROPERTY_DIRECTFB_INTERFACE
        XL_WINDOW_PROPERTY_DIRECTFB_WINDOW
        XL_WINDOW_PROPERTY_DIRECTFB_SURFACE
        XL_WINDOW_PROPERTY_COCOA_WINDOW
        XL_WINDOW_PROPERTY_UIKIT_WINDOW
        XL_WINDOW_PROPERTY_UIKIT_FRAMEBUFFER
        XL_WINDOW_PROPERTY_UIKIT_COLORBUFFER
        XL_WINDOW_PROPERTY_UIKIT_RESOLVE_FRAMEBUFFER
        XL_WINDOW_PROPERTY_WAYLAND_DISPLAY
        XL_WINDOW_PROPERTY_WAYLAND_SURFACE
        XL_WINDOW_PROPERTY_WAYLAND_SHELL_SURFACE
        XL_WINDOW_PROPERTY_MIR_CONNECTION
        XL_WINDOW_PROPERTY_MIR_SURFACE
        XL_WINDOW_PROPERTY_ANDROID_WINDOW
        XL_WINDOW_PROPERTY_ANDROID_SURFACE
        XL_WINDOW_PROPERTY_VIVANTE_DISPLAY
        XL_WINDOW_PROPERTY_VIVANTE_WINDOW
        XL_WINDOW_PROPERTY_COUNT

    const char* xl_window_property_name[]
    const char* xl_window_property_type[]

    void xl_window_set_int(xl_window_t* win, xl_window_property_t prop, int val)
    int xl_window_get_int(xl_window_t* win, xl_window_property_t prop)

    void xl_window_set_flt(xl_window_t* win, xl_window_property_t prop, float val)
    float xl_window_get_flt(xl_window_t* win, xl_window_property_t prop)

    void xl_window_set_str(xl_window_t* win, xl_window_property_t prop, const char* val)
    const char* xl_window_get_str(xl_window_t* win, xl_window_property_t prop)

    void xl_window_set_ptr(xl_window_t* win, xl_window_property_t prop, void* val)
    void* xl_window_get_ptr(xl_window_t* win, xl_window_property_t prop)

    void xl_window_set_img(xl_window_t* win, xl_window_property_t prop, ae_image_t* val)
    ae_image_t* xl_window_get_img(xl_window_t* win, xl_window_property_t prop)

    void xl_window_close(xl_window_t* window)

    void xl_window_clear(xl_window_t* window, float r, float g, float b)
    void xl_window_flip(xl_window_t* window)
    void xl_window_screenshot(xl_window_t* window, ae_image_t* image)

    ctypedef enum xl_window_driver_t:
        XL_WINDOW_DRIVER_UNKNOWN
        XL_WINDOW_DRIVER_WINDOWS
        XL_WINDOW_DRIVER_X11
        XL_WINDOW_DRIVER_DIRECTFB
        XL_WINDOW_DRIVER_COCOA
        XL_WINDOW_DRIVER_UIKIT
        XL_WINDOW_DRIVER_WAYLAND
        XL_WINDOW_DRIVER_MIR
        XL_WINDOW_DRIVER_WINRT
        XL_WINDOW_DRIVER_ANDROID
        XL_WINDOW_DRIVER_VIVANTE
        XL_WINDOW_DRIVER_OS2
        XL_WINDOW_DRIVER_COUNT

    const char* xl_window_driver_name[] # platform strings
    const char* xl_window_driver_short_name[]

    size_t xl_window_count_all()
    void xl_window_list_all(xl_window_t** windows)

    void xl_window_print_all()
    void xl_window_close_all()

    size_t xl_window_count_textures(xl_window_t* window)
    void xl_window_list_textures(xl_window_t* window, xl_texture_t** textures)

    void xl_window_print_textures(xl_window_t* window)
    void xl_window_close_textures(xl_window_t* window)

    size_t xl_window_count_fonts(xl_window_t* window)
    void xl_window_list_fonts(xl_window_t* window, xl_font_t** fonts)

    void xl_window_print_fonts(xl_window_t* window)
    void xl_window_close_fonts(xl_window_t* window)

    # ==========================================================================
    # ~ [ shape renderer ]
    # ==========================================================================

    void xl_draw_rect_ex(xl_window_t* window, float* rect, float* color,
                        double angle, float* center, const int outline)

    void xl_draw_rect(xl_window_t* window, float* rect, float* color)

    void xl_draw_points(xl_window_t* window, float* points, size_t count, float* color)
    void xl_draw_point(xl_window_t* window, float* point, float* color)

    void xl_draw_line(xl_window_t* window, float* a, float* b, float* color)

    void xl_draw_curve(xl_window_t* window, float* a, float* b, float* color,
                            ae_ease_mode_t mode, const size_t num_divisions)

    void xl_draw_circle(xl_window_t * window, float * center, float radius,
                    float * color, int outline, const size_t num_divisions)

    void xl_draw_triangle(xl_window_t * window, float* a, float* b, float* c,
                                                float* color, int outline)

    # ==========================================================================
    # ~ [ texture renderer ]
    # ==========================================================================

    xl_texture_t* xl_texture_create(xl_window_t* window, int width, int height)

    ctypedef enum xl_texture_property_t:
        XL_TEXTURE_PROPERTY_TOTAL
        XL_TEXTURE_PROPERTY_ID
        XL_TEXTURE_PROPERTY_DRAW_CALLS
        XL_TEXTURE_PROPERTY_WINDOW
        XL_TEXTURE_PROPERTY_WIDTH
        XL_TEXTURE_PROPERTY_HEIGHT
        XL_TEXTURE_PROPERTY_IMAGE
        XL_TEXTURE_PROPERTY_COPY_ENABLED
        XL_TEXTURE_PROPERTY_STATUS
        XL_TEXTURE_PROPERTY_PATH
        XL_TEXTURE_PROPERTY_NAME
        XL_TEXTURE_PROPERTY_RED
        XL_TEXTURE_PROPERTY_GREEN
        XL_TEXTURE_PROPERTY_BLUE
        XL_TEXTURE_PROPERTY_ALPHA
        XL_TEXTURE_PROPERTY_RGB
        XL_TEXTURE_PROPERTY_RGBA
        XL_TEXTURE_PROPERTY_HIGH_QUALITY
        XL_TEXTURE_PROPERTY_SCALE_FILTER
        XL_TEXTURE_PROPERTY_SUBPIXEL
        XL_TEXTURE_PROPERTY_FLIP
        XL_TEXTURE_PROPERTY_OPEN
        XL_TEXTURE_PROPERTY_COUNT

    const char* xl_texture_property_name[]
    const char* xl_texture_property_type[]

    void xl_texture_set_int(xl_texture_t*, xl_texture_property_t, int)
    int xl_texture_get_int(xl_texture_t*, xl_texture_property_t)

    void xl_texture_set_flt(xl_texture_t*, xl_texture_property_t, float)
    float xl_texture_get_flt(xl_texture_t*, xl_texture_property_t)

    void xl_texture_set_str(xl_texture_t*, xl_texture_property_t, const char*)
    const char* xl_texture_get_str(xl_texture_t*, xl_texture_property_t)

    void xl_texture_set_ptr(xl_texture_t*, xl_texture_property_t, void*)
    void* xl_texture_get_ptr(xl_texture_t*, xl_texture_property_t)

    void xl_texture_set_img(xl_texture_t*, xl_texture_property_t, ae_image_t*)
    ae_image_t* xl_texture_get_img(xl_texture_t*, xl_texture_property_t)

    void xl_texture_close(xl_texture_t* texture)

    ctypedef enum xl_texture_flip_t:
        XL_TEXTURE_FLIP_NONE
        XL_TEXTURE_FLIP_HORIZONTAL
        XL_TEXTURE_FLIP_VERTICAL
        XL_TEXTURE_FLIP_BOTH
        XL_TEXTURE_FLIP_COUNT

    const char* xl_texture_flip_name[]
    const char* xl_texture_flip_short_name[]

    xl_texture_flip_t xl_texture_flip_from_short_name(const char*) # "str" -> mode

    ctypedef enum xl_texture_scale_filter_t:
        XL_TEXTURE_SCALE_FILTER_NEAREST
        XL_TEXTURE_SCALE_FILTER_LINEAR
        XL_TEXTURE_SCALE_FILTER_ANISOTROPIC
        XL_TEXTURE_SCALE_FILTER_COUNT

    const char* xl_texture_scale_filter_name[]
    const char* xl_texture_scale_filter_short_name[]

    xl_texture_scale_filter_t xl_texture_scale_filter_from_short_name(const char*)

    void xl_texture_draw_ex(xl_texture_t* texture, float* src_rect,
                    float* dst_rect, double angle, float* center)

    void xl_texture_draw(xl_texture_t* texture, const float xy[2])

    xl_texture_t* xl_texture_load_from_memory(xl_window_t* window, void* buf,
                                                                size_t size)

    xl_texture_t* xl_texture_load_from_memory_ex(xl_window_t* win, void* buf,
                                size_t size, ae_image_error_t* error_status)

    xl_texture_t* xl_texture_load_ex(xl_window_t* window, const char* filename,
                                                ae_image_error_t* error_status)

    xl_texture_t* xl_texture_load(xl_window_t* window, const char* filename)

    size_t xl_texture_count_all()
    void xl_texture_list_all(xl_texture_t** textures)

    void xl_texture_print_all()
    void xl_texture_close_all()

    # ==========================================================================
    # ~ [ font renderer ]
    # ==========================================================================

    ctypedef enum xl_font_property_t:
        XL_FONT_PROPERTY_TOTAL
        XL_FONT_PROPERTY_ID
        XL_FONT_PROPERTY_WINDOW
        XL_FONT_PROPERTY_POINT_SIZE
        XL_FONT_PROPERTY_LINE_SKIP
        XL_FONT_PROPERTY_STATUS
        XL_FONT_PROPERTY_PATH
        XL_FONT_PROPERTY_NAME
        XL_FONT_PROPERTY_RED
        XL_FONT_PROPERTY_GREEN
        XL_FONT_PROPERTY_BLUE
        XL_FONT_PROPERTY_ALPHA
        XL_FONT_PROPERTY_RGB
        XL_FONT_PROPERTY_RGBA
        XL_FONT_PROPERTY_OPEN
        XL_FONT_PROPERTY_COUNT

    const char* xl_font_property_name[]
    const char* xl_font_property_type[]

    void xl_font_set_int(xl_font_t* font, xl_font_property_t prop, int)
    int xl_font_get_int(xl_font_t* font, xl_font_property_t prop)

    void xl_font_set_flt(xl_font_t* font, xl_font_property_t prop, float)
    float xl_font_get_flt(xl_font_t* font, xl_font_property_t prop)

    void xl_font_set_str(xl_font_t* font, xl_font_property_t prop, const char*)
    const char* xl_font_get_str(xl_font_t* font, xl_font_property_t prop)

    void xl_font_set_ptr(xl_font_t* font, xl_font_property_t prop, void*)
    void* xl_font_get_ptr(xl_font_t* font, xl_font_property_t prop)

    void xl_font_close(xl_font_t* font)

    void xl_font_text_size(xl_font_t* font, int* w, int* h, const char* fmt, ...)
    void xl_font_render_image(xl_font_t* font, ae_image_t* img, const char* fmt, ...)
    xl_texture_t* xl_font_render_texture(xl_font_t* font, const char* fmt, ...)

    void xl_font_blit(xl_font_t * font, ae_image_t * image, int x, int y,
                        int r, int g, int b, int a, const char* fmt, ...)

    void xl_font_draw(xl_font_t* font, float xy[2], const char* fmt, ...)

    xl_font_t* xl_font_load_from_memory(xl_window_t* window, void* ptr,
                                        size_t length, int point_size)

    xl_font_t* xl_font_load(xl_window_t* window, const char* filename, int point_size)
    xl_font_t* xl_font_load_system_monospace(xl_window_t* window, int point_size)

    size_t xl_font_count_all()
    void xl_font_list_all(xl_font_t** fonts)

    void xl_font_print_all()
    void xl_font_close_all()

    # ==========================================================================
    # ~ [ streaming music ]
    # ==========================================================================

    ctypedef enum xl_music_property_t:
        XL_MUSIC_PROPERTY_PLAYING
        XL_MUSIC_PROPERTY_PAUSED
        XL_MUSIC_PROPERTY_FADING_IN
        XL_MUSIC_PROPERTY_FADING_OUT
        XL_MUSIC_PROPERTY_STATUS
        XL_MUSIC_PROPERTY_DURATION
        XL_MUSIC_PROPERTY_POSITION
        XL_MUSIC_PROPERTY_VOLUME
        XL_MUSIC_PROPERTY_PATH
        XL_MUSIC_PROPERTY_NAME
        XL_MUSIC_PROPERTY_COUNT

    const char* xl_music_property_name[]
    const char* xl_music_property_type[]

    void xl_music_set_int(xl_music_property_t property, int value)
    int xl_music_get_int(xl_music_property_t property)

    void xl_music_set_dbl(xl_music_property_t property, double value)
    double xl_music_get_dbl(xl_music_property_t property)

    void xl_music_set_str(xl_music_property_t property, const char* value)
    const char* xl_music_get_str(xl_music_property_t property)

    void xl_music_fade_in(const char* name, int loop, double fade, double start)
    void xl_music_fade_out(double fade_out)

    void xl_music_play(const char* filename)
    void xl_music_stop()

    # ==========================================================================
    # ~ [ sound effects ]
    # ==========================================================================

    ctypedef enum xl_sound_property_t:
        XL_SOUND_PROPERTY_TOTAL
        XL_SOUND_PROPERTY_ID
        XL_SOUND_PROPERTY_DURATION
        XL_SOUND_PROPERTY_VOLUME
        XL_SOUND_PROPERTY_STATUS
        XL_SOUND_PROPERTY_PATH
        XL_SOUND_PROPERTY_NAME
        XL_SOUND_PROPERTY_OPEN
        XL_SOUND_PROPERTY_COUNT

    const char* xl_sound_property_name[]
    const char* xl_sound_property_type[]

    void xl_sound_set_int(xl_sound_t* sound, xl_sound_property_t prop, int val)
    int xl_sound_get_int(xl_sound_t* sound, xl_sound_property_t prop)

    void xl_sound_set_dbl(xl_sound_t* sound, xl_sound_property_t prop, double val)
    double xl_sound_get_dbl(xl_sound_t* sound, xl_sound_property_t prop)

    void xl_sound_set_str(xl_sound_t* sound, xl_sound_property_t prop, const char* val)
    const char* xl_sound_get_str(xl_sound_t* sound, xl_sound_property_t prop)

    void xl_sound_close(xl_sound_t* sound)

    void xl_sound_fade_in(xl_sound_t* sound, int count, double fade_in, double length)
    void xl_sound_play(xl_sound_t* sound)

    void xl_sound_fade_out(xl_sound_t* sound, double fade_out)
    void xl_sound_stop(xl_sound_t* sound)

    xl_sound_t* xl_sound_load_from_memory(void* ptr, size_t length)
    xl_sound_t* xl_sound_load(const char* filename)

    size_t xl_sound_count_all()
    void xl_sound_list_all(xl_sound_t** sounds)

    void xl_sound_print_all()
    void xl_sound_close_all()

    # ==========================================================================
    # ~ [ keyboard input ]
    # ==========================================================================

    xl_keyboard_t* xl_primary_keyboard()

    ctypedef enum xl_keyboard_property_t:
        XL_KEYBOARD_PROPERTY_TOTAL
        XL_KEYBOARD_PROPERTY_ID
        XL_KEYBOARD_PROPERTY_DOWN_MODS
        XL_KEYBOARD_PROPERTY_UP_MODS
        XL_KEYBOARD_PROPERTY_DOWN_KEYS
        XL_KEYBOARD_PROPERTY_UP_KEYS
        XL_KEYBOARD_PROPERTY_LAST_PRESSED_KEY
        XL_KEYBOARD_PROPERTY_LAST_RELEASED_KEY
        XL_KEYBOARD_PROPERTY_LAST_PRESSED_TIME
        XL_KEYBOARD_PROPERTY_LAST_RELEASED_TIME
        XL_KEYBOARD_PROPERTY_STATUS
        XL_KEYBOARD_PROPERTY_NAME
        XL_KEYBOARD_PROPERTY_PRIMARY
        XL_KEYBOARD_PROPERTY_OPEN
        XL_KEYBOARD_PROPERTY_COUNT

    const char* xl_keyboard_property_name[]
    const char* xl_keyboard_property_type[]

    void xl_keyboard_set_int(xl_keyboard_t* keyboard, xl_keyboard_property_t prop, int val)
    int xl_keyboard_get_int(xl_keyboard_t* keyboard, xl_keyboard_property_t prop) # integer

    void xl_keyboard_set_dbl(xl_keyboard_t* keyboard, xl_keyboard_property_t prop, double val)
    double xl_keyboard_get_dbl(xl_keyboard_t* keyboard, xl_keyboard_property_t prop) # double

    void xl_keyboard_set_str(xl_keyboard_t* keyboard, xl_keyboard_property_t prop, const char* val)
    const char* xl_keyboard_get_str(xl_keyboard_t* keyboard, xl_keyboard_property_t prop) # string

    void xl_keyboard_set_ptr(xl_keyboard_t* keyboard, xl_keyboard_property_t prop, void* val)
    void* xl_keyboard_get_ptr(xl_keyboard_t* keyboard, xl_keyboard_property_t prop) # pointer

    size_t xl_keyboard_count_all()
    void xl_keyboard_list_all(xl_keyboard_t** keyboards)

    void xl_keyboard_print_all()

    # ===== [ modifiers and keys ] =============================================

    ctypedef enum xl_keyboard_mod_index_t:
        XL_KEYBOARD_MOD_INDEX_LEFT_SHIFT
        XL_KEYBOARD_MOD_INDEX_RIGHT_SHIFT
        XL_KEYBOARD_MOD_INDEX_LEFT_CONTROL
        XL_KEYBOARD_MOD_INDEX_RIGHT_CONTROL
        XL_KEYBOARD_MOD_INDEX_LEFT_ALT
        XL_KEYBOARD_MOD_INDEX_RIGHT_ALT
        XL_KEYBOARD_MOD_INDEX_LEFT_GUI
        XL_KEYBOARD_MOD_INDEX_RIGHT_GUI
        XL_KEYBOARD_MOD_INDEX_NUMLOCK
        XL_KEYBOARD_MOD_INDEX_CAPSLOCK
        XL_KEYBOARD_MOD_INDEX_COUNT

    const char* xl_keyboard_mod_index_name[]
    const char* xl_keyboard_mod_short_name[]

    ctypedef enum xl_keyboard_mod_bit_t:
        XL_KEYBOARD_MOD_BIT_LEFT_SHIFT
        XL_KEYBOARD_MOD_BIT_RIGHT_SHIFT
        XL_KEYBOARD_MOD_BIT_SHIFT
        XL_KEYBOARD_MOD_BIT_LEFT_CONTROL
        XL_KEYBOARD_MOD_BIT_RIGHT_CONTROL
        XL_KEYBOARD_MOD_BIT_CONTROL
        XL_KEYBOARD_MOD_BIT_LEFT_ALT
        XL_KEYBOARD_MOD_BIT_RIGHT_ALT
        XL_KEYBOARD_MOD_BIT_ALT
        XL_KEYBOARD_MOD_BIT_LEFT_GUI
        XL_KEYBOARD_MOD_BIT_RIGHT_GUI
        XL_KEYBOARD_MOD_BIT_GUI
        XL_KEYBOARD_MOD_BIT_NUMLOCK
        XL_KEYBOARD_MOD_BIT_CAPSLOCK

    xl_keyboard_mod_index_t \
    xl_keyboard_mod_index_from_short_name(const char* name)

    xl_keyboard_mod_bit_t \
    xl_keyboard_mod_bit_from_short_name(const char* name)

    int xl_keyboard_mod_is_down(xl_keyboard_t*, xl_keyboard_mod_index_t)
    int xl_keyboard_mod_is_up(xl_keyboard_t*, xl_keyboard_mod_index_t)

    ctypedef enum xl_keyboard_key_index_t:
        XL_KEYBOARD_KEY_INDEX_A
        XL_KEYBOARD_KEY_INDEX_B
        XL_KEYBOARD_KEY_INDEX_C
        XL_KEYBOARD_KEY_INDEX_D
        XL_KEYBOARD_KEY_INDEX_E
        XL_KEYBOARD_KEY_INDEX_F
        XL_KEYBOARD_KEY_INDEX_G
        XL_KEYBOARD_KEY_INDEX_H
        XL_KEYBOARD_KEY_INDEX_I
        XL_KEYBOARD_KEY_INDEX_J
        XL_KEYBOARD_KEY_INDEX_K
        XL_KEYBOARD_KEY_INDEX_L
        XL_KEYBOARD_KEY_INDEX_M
        XL_KEYBOARD_KEY_INDEX_N
        XL_KEYBOARD_KEY_INDEX_O
        XL_KEYBOARD_KEY_INDEX_P
        XL_KEYBOARD_KEY_INDEX_Q
        XL_KEYBOARD_KEY_INDEX_R
        XL_KEYBOARD_KEY_INDEX_S
        XL_KEYBOARD_KEY_INDEX_T
        XL_KEYBOARD_KEY_INDEX_U
        XL_KEYBOARD_KEY_INDEX_V
        XL_KEYBOARD_KEY_INDEX_W
        XL_KEYBOARD_KEY_INDEX_X
        XL_KEYBOARD_KEY_INDEX_Y
        XL_KEYBOARD_KEY_INDEX_Z
        XL_KEYBOARD_KEY_INDEX_1
        XL_KEYBOARD_KEY_INDEX_2
        XL_KEYBOARD_KEY_INDEX_3
        XL_KEYBOARD_KEY_INDEX_4
        XL_KEYBOARD_KEY_INDEX_5
        XL_KEYBOARD_KEY_INDEX_6
        XL_KEYBOARD_KEY_INDEX_7
        XL_KEYBOARD_KEY_INDEX_8
        XL_KEYBOARD_KEY_INDEX_9
        XL_KEYBOARD_KEY_INDEX_0
        XL_KEYBOARD_KEY_INDEX_RETURN
        XL_KEYBOARD_KEY_INDEX_ESCAPE
        XL_KEYBOARD_KEY_INDEX_BACKSPACE
        XL_KEYBOARD_KEY_INDEX_TAB
        XL_KEYBOARD_KEY_INDEX_SPACE
        XL_KEYBOARD_KEY_INDEX_MINUS
        XL_KEYBOARD_KEY_INDEX_EQUALS
        XL_KEYBOARD_KEY_INDEX_LEFT_BRACKET
        XL_KEYBOARD_KEY_INDEX_RIGHT_BRACKET
        XL_KEYBOARD_KEY_INDEX_BACKSLASH
        XL_KEYBOARD_KEY_INDEX_SEMICOLON
        XL_KEYBOARD_KEY_INDEX_APOSTROPHE
        XL_KEYBOARD_KEY_INDEX_GRAVE
        XL_KEYBOARD_KEY_INDEX_COMMA
        XL_KEYBOARD_KEY_INDEX_PERIOD
        XL_KEYBOARD_KEY_INDEX_SLASH
        XL_KEYBOARD_KEY_INDEX_F1
        XL_KEYBOARD_KEY_INDEX_F2
        XL_KEYBOARD_KEY_INDEX_F3
        XL_KEYBOARD_KEY_INDEX_F4
        XL_KEYBOARD_KEY_INDEX_F5
        XL_KEYBOARD_KEY_INDEX_F6
        XL_KEYBOARD_KEY_INDEX_F7
        XL_KEYBOARD_KEY_INDEX_F8
        XL_KEYBOARD_KEY_INDEX_F9
        XL_KEYBOARD_KEY_INDEX_F10
        XL_KEYBOARD_KEY_INDEX_F11
        XL_KEYBOARD_KEY_INDEX_F12
        XL_KEYBOARD_KEY_INDEX_PRINT_SCREEN
        XL_KEYBOARD_KEY_INDEX_SCROLL_LOCK
        XL_KEYBOARD_KEY_INDEX_PAUSE
        XL_KEYBOARD_KEY_INDEX_INSERT
        XL_KEYBOARD_KEY_INDEX_DELETE
        XL_KEYBOARD_KEY_INDEX_HOME
        XL_KEYBOARD_KEY_INDEX_PAGE_UP
        XL_KEYBOARD_KEY_INDEX_PAGE_DOWN
        XL_KEYBOARD_KEY_INDEX_END
        XL_KEYBOARD_KEY_INDEX_RIGHT
        XL_KEYBOARD_KEY_INDEX_LEFT
        XL_KEYBOARD_KEY_INDEX_DOWN
        XL_KEYBOARD_KEY_INDEX_UP
        XL_KEYBOARD_KEY_INDEX_KP_DIVIDE
        XL_KEYBOARD_KEY_INDEX_KP_MULTIPLY
        XL_KEYBOARD_KEY_INDEX_KP_MINUS
        XL_KEYBOARD_KEY_INDEX_KP_PLUS
        XL_KEYBOARD_KEY_INDEX_KP_ENTER
        XL_KEYBOARD_KEY_INDEX_KP_PERIOD
        XL_KEYBOARD_KEY_INDEX_KP_1
        XL_KEYBOARD_KEY_INDEX_KP_2
        XL_KEYBOARD_KEY_INDEX_KP_3
        XL_KEYBOARD_KEY_INDEX_KP_4
        XL_KEYBOARD_KEY_INDEX_KP_5
        XL_KEYBOARD_KEY_INDEX_KP_6
        XL_KEYBOARD_KEY_INDEX_KP_7
        XL_KEYBOARD_KEY_INDEX_KP_8
        XL_KEYBOARD_KEY_INDEX_KP_9
        XL_KEYBOARD_KEY_INDEX_KP_0
        XL_KEYBOARD_KEY_INDEX_LEFT_SHIFT
        XL_KEYBOARD_KEY_INDEX_RIGHT_SHIFT
        XL_KEYBOARD_KEY_INDEX_LEFT_CONTROL
        XL_KEYBOARD_KEY_INDEX_RIGHT_CONTROL
        XL_KEYBOARD_KEY_INDEX_LEFT_ALT
        XL_KEYBOARD_KEY_INDEX_RIGHT_ALT
        XL_KEYBOARD_KEY_INDEX_LEFT_GUI
        XL_KEYBOARD_KEY_INDEX_RIGHT_GUI
        XL_KEYBOARD_KEY_INDEX_NUMLOCK
        XL_KEYBOARD_KEY_INDEX_CAPSLOCK
        XL_KEYBOARD_KEY_INDEX_COUNT

    const char* xl_keyboard_key_index_name[]
    const char* xl_keyboard_key_short_name[]

    # we can't fit all keys into a 32-bit bitmask, so we use a key bitvector
    ctypedef u8 xl_keyboard_key_bit_t[(XL_KEYBOARD_KEY_INDEX_COUNT + 7) / 8]

    xl_keyboard_key_index_t \
    xl_keyboard_key_index_from_short_name(const char* name)

    int xl_keyboard_key_is_down(xl_keyboard_t*, xl_keyboard_key_index_t)
    int xl_keyboard_key_is_up(xl_keyboard_t*, xl_keyboard_key_index_t)

    double xl_keyboard_get_last_key_pressed_time (xl_keyboard_t* keyboard,
                                            xl_keyboard_key_index_t key)

    double xl_keyboard_get_last_key_released_time(xl_keyboard_t* keyboard,
                                            xl_keyboard_key_index_t key)

    void xl_keyboard_clear_history(xl_keyboard_t* keyboard)

    int xl_keyboard_check_history(xl_keyboard_t* keyboard, # check for combo
                    const xl_keyboard_key_bit_t* const masks, size_t count)

    # ==========================================================================
    # ~ [ mouse input ]
    # ==========================================================================

    xl_mouse_t* xl_primary_mouse()

    ctypedef enum xl_mouse_property_t:
        XL_MOUSE_PROPERTY_TOTAL
        XL_MOUSE_PROPERTY_ID
        XL_MOUSE_PROPERTY_DOWN_BUTTONS
        XL_MOUSE_PROPERTY_UP_BUTTONS
        XL_MOUSE_PROPERTY_TRIBOOL
        XL_MOUSE_PROPERTY_LAST_PRESSED_BUTTON
        XL_MOUSE_PROPERTY_LAST_RELEASED_BUTTON
        XL_MOUSE_PROPERTY_LAST_PRESSED_TIME
        XL_MOUSE_PROPERTY_LAST_RELEASED_TIME
        XL_MOUSE_PROPERTY_WINDOW
        XL_MOUSE_PROPERTY_X
        XL_MOUSE_PROPERTY_Y
        XL_MOUSE_PROPERTY_DX
        XL_MOUSE_PROPERTY_DY
        XL_MOUSE_PROPERTY_RELATIVE
        XL_MOUSE_PROPERTY_VISIBLE
        XL_MOUSE_PROPERTY_STATUS
        XL_MOUSE_PROPERTY_NAME
        XL_MOUSE_PROPERTY_PRIMARY
        XL_MOUSE_PROPERTY_OPEN
        XL_MOUSE_PROPERTY_COUNT

    const char* xl_mouse_property_name[]
    const char* xl_mouse_property_type[]

    void xl_mouse_set_int(xl_mouse_t* mouse, xl_mouse_property_t prop, int val)
    int xl_mouse_get_int(xl_mouse_t* mouse, xl_mouse_property_t prop) # integer

    void xl_mouse_set_dbl(xl_mouse_t* mouse, xl_mouse_property_t prop, double val)
    double xl_mouse_get_dbl(xl_mouse_t* mouse, xl_mouse_property_t prop) # double

    void xl_mouse_set_str(xl_mouse_t* mouse, xl_mouse_property_t prop, const char* val)
    const char* xl_mouse_get_str(xl_mouse_t* mouse, xl_mouse_property_t prop) # string

    void xl_mouse_set_ptr(xl_mouse_t* mouse, xl_mouse_property_t prop, void* val)
    void* xl_mouse_get_ptr(xl_mouse_t* mouse, xl_mouse_property_t prop) # pointer

    size_t xl_mouse_count_all()
    void xl_mouse_list_all(xl_mouse_t** mice)

    void xl_mouse_print_all()

    # ===== [ mouse buttons ] ==================================================

    ctypedef enum xl_mouse_button_index_t:
        XL_MOUSE_BUTTON_INDEX_LEFT
        XL_MOUSE_BUTTON_INDEX_MIDDLE
        XL_MOUSE_BUTTON_INDEX_RIGHT
        XL_MOUSE_BUTTON_INDEX_COUNT

    const char* xl_mouse_button_index_name[]
    const char* xl_mouse_button_short_name[]

    ctypedef enum xl_mouse_button_bit_t:
        pass

    xl_mouse_button_index_t \
    xl_mouse_button_index_from_short_name(const char* name)

    xl_mouse_button_bit_t \
    xl_mouse_button_bit_from_short_name(const char* name)

    int xl_mouse_button_is_down(xl_mouse_t* c, xl_mouse_button_index_t b)
    int xl_mouse_button_is_up(xl_mouse_t* c, xl_mouse_button_index_t b)

    double xl_mouse_get_last_button_pressed_time(xl_mouse_t * mouse,
                                    xl_mouse_button_index_t button)

    double xl_mouse_get_last_button_released_time(xl_mouse_t* mouse,
                                    xl_mouse_button_index_t button)

    void xl_mouse_clear_history(xl_mouse_t* mouse) # mouse button history

    int xl_mouse_check_history(xl_mouse_t* mouse, const int* const masks,
                                                            size_t count)

    # ==========================================================================
    # ~ [ controller input ]
    # ==========================================================================

    xl_controller_t* xl_primary_controller()

    ctypedef enum xl_controller_property_t:
        XL_CONTROLLER_PROPERTY_TOTAL
        XL_CONTROLLER_PROPERTY_ID
        XL_CONTROLLER_PROPERTY_DOWN_BUTTONS
        XL_CONTROLLER_PROPERTY_UP_BUTTONS
        XL_CONTROLLER_PROPERTY_SHOULDER_TRIBOOL
        XL_CONTROLLER_PROPERTY_DPAD_HORIZONTAL_TRIBOOL
        XL_CONTROLLER_PROPERTY_DPAD_VERTICAL_TRIBOOL
        XL_CONTROLLER_PROPERTY_STICK_TRIBOOL
        XL_CONTROLLER_PROPERTY_LAST_PRESSED_BUTTON
        XL_CONTROLLER_PROPERTY_LAST_RELEASED_BUTTON
        XL_CONTROLLER_PROPERTY_LAST_PRESSED_TIME
        XL_CONTROLLER_PROPERTY_LAST_RELEASED_TIME
        XL_CONTROLLER_PROPERTY_RIGHT_TRIGGER
        XL_CONTROLLER_PROPERTY_LEFT_TRIGGER
        XL_CONTROLLER_PROPERTY_RIGHT_DEADZONE_MODE
        XL_CONTROLLER_PROPERTY_RIGHT_DEADZONE_VALUE
        XL_CONTROLLER_PROPERTY_LEFT_DEADZONE_MODE
        XL_CONTROLLER_PROPERTY_LEFT_DEADZONE_VALUE
        XL_CONTROLLER_PROPERTY_RIGHT_STICK_ANGLE
        XL_CONTROLLER_PROPERTY_RIGHT_STICK_MAGNITUDE
        XL_CONTROLLER_PROPERTY_LEFT_STICK_ANGLE
        XL_CONTROLLER_PROPERTY_LEFT_STICK_MAGNITUDE
        XL_CONTROLLER_PROPERTY_RIGHT_STICK_X
        XL_CONTROLLER_PROPERTY_RIGHT_STICK_Y
        XL_CONTROLLER_PROPERTY_LEFT_STICK_X
        XL_CONTROLLER_PROPERTY_LEFT_STICK_Y
        XL_CONTROLLER_PROPERTY_PRIMARY
        XL_CONTROLLER_PROPERTY_OPEN
        XL_CONTROLLER_PROPERTY_STATUS
        XL_CONTROLLER_PROPERTY_NAME
        XL_CONTROLLER_PROPERTY_COUNT

    const char* xl_controller_property_name[]
    const char* xl_controller_property_type[]

    void xl_controller_set_int(xl_controller_t*, xl_controller_property_t, int)
    int xl_controller_get_int(xl_controller_t*, xl_controller_property_t)

    void xl_controller_set_flt(xl_controller_t*, xl_controller_property_t, float)
    float xl_controller_get_flt(xl_controller_t*, xl_controller_property_t)

    void xl_controller_set_dbl(xl_controller_t*, xl_controller_property_t, double)
    double xl_controller_get_dbl(xl_controller_t*, xl_controller_property_t)

    void xl_controller_set_str(xl_controller_t*, xl_controller_property_t, const char*)
    const char* xl_controller_get_str(xl_controller_t*, xl_controller_property_t)

    size_t xl_controller_count_all()
    void xl_controller_list_all(xl_controller_t** controllers)

    void xl_controller_print_all()

    # ===== [ digital buttons ] ================================================

    ctypedef enum xl_controller_button_index_t:
        XL_CONTROLLER_BUTTON_INDEX_A
        XL_CONTROLLER_BUTTON_INDEX_B
        XL_CONTROLLER_BUTTON_INDEX_X
        XL_CONTROLLER_BUTTON_INDEX_Y
        XL_CONTROLLER_BUTTON_INDEX_SELECT
        XL_CONTROLLER_BUTTON_INDEX_START
        XL_CONTROLLER_BUTTON_INDEX_LEFT_STICK
        XL_CONTROLLER_BUTTON_INDEX_RIGHT_STICK
        XL_CONTROLLER_BUTTON_INDEX_LEFT_SHOULDER
        XL_CONTROLLER_BUTTON_INDEX_RIGHT_SHOULDER
        XL_CONTROLLER_BUTTON_INDEX_DPAD_UP
        XL_CONTROLLER_BUTTON_INDEX_DPAD_DOWN
        XL_CONTROLLER_BUTTON_INDEX_DPAD_LEFT
        XL_CONTROLLER_BUTTON_INDEX_DPAD_RIGHT
        XL_CONTROLLER_BUTTON_INDEX_COUNT

    const char* xl_controller_button_index_name[]
    const char* xl_controller_button_short_name[]

    ctypedef enum xl_controller_button_bit_t:
        pass

    xl_controller_button_index_t \
    xl_controller_button_index_from_short_name(const char* name)

    xl_controller_button_bit_t \
    xl_controller_button_bit_from_short_name(const char* name)

    int xl_controller_button_is_down(xl_controller_t*, xl_controller_button_index_t)
    int xl_controller_button_is_up(xl_controller_t*, xl_controller_button_index_t)

    double xl_controller_get_last_button_pressed_time( xl_controller_t * controller,
                                                xl_controller_button_index_t button)

    double xl_controller_get_last_button_released_time(xl_controller_t * controller,
                                                xl_controller_button_index_t button)

    void xl_controller_clear_history(xl_controller_t* controller)

    int xl_controller_check_history( xl_controller_t* controller,
                            const int* const masks, size_t count)

    # ===== [ analog axes & triggers ] =========================================

    double xl_controller_get_trigger(xl_controller_t* controller, char which)

    void xl_controller_get_deadzone(xl_controller_t * controller, char which,
                        xl_controller_deadzone_mode_t * mode, double * value)

    void xl_controller_set_deadzone(xl_controller_t * controller, char which,
                            xl_controller_deadzone_mode_t mode, double value)

    double xl_controller_get_stick_angle(xl_controller_t * c, char which)
    double xl_controller_get_stick_magnitude(xl_controller_t * c, char which)

    void xl_controller_get_stick(xl_controller_t* controller,
                            char which, double* x, double* y)

    ctypedef enum xl_controller_deadzone_mode_t:
        XL_CONTROLLER_DEADZONE_MODE_NONE
        XL_CONTROLLER_DEADZONE_MODE_AXIAL
        XL_CONTROLLER_DEADZONE_MODE_RADIAL
        XL_CONTROLLER_DEADZONE_MODE_SCALED_RADIAL
        XL_CONTROLLER_DEADZONE_MODE_X_BOWTIE
        XL_CONTROLLER_DEADZONE_MODE_Y_BOWTIE
        XL_CONTROLLER_DEADZONE_MODE_COUNT

    const char* xl_controller_deadzone_mode_name[]
    const char* xl_controller_deadzone_short_name[]

    xl_controller_deadzone_mode_t \
    xl_controller_deadzone_mode_from_short_name(const char* name)

    # ==========================================================================
    # ~ [ atlas animation ]
    # ==========================================================================

    xl_animation_t* xl_animation_create()
    xl_animation_t* xl_animation_copy(xl_animation_t* animation)

    ctypedef enum xl_animation_property_t:
        XL_ANIMATION_PROPERTY_TOTAL
        XL_ANIMATION_PROPERTY_ID
        XL_ANIMATION_PROPERTY_ATLAS
        XL_ANIMATION_PROPERTY_OWNS_ATLAS
        XL_ANIMATION_PROPERTY_FRAME_WIDTH
        XL_ANIMATION_PROPERTY_FRAME_HEIGHT
        XL_ANIMATION_PROPERTY_FIRST_FRAME
        XL_ANIMATION_PROPERTY_FRAME_COUNT
        XL_ANIMATION_PROPERTY_FRAME_TIME
        XL_ANIMATION_PROPERTY_TOTAL_TIME
        XL_ANIMATION_PROPERTY_CURRENT_FRAME
        XL_ANIMATION_PROPERTY_POSITION
        XL_ANIMATION_PROPERTY_LOOPS
        XL_ANIMATION_PROPERTY_FINISHED
        XL_ANIMATION_PROPERTY_STATUS
        XL_ANIMATION_PROPERTY_PATH
        XL_ANIMATION_PROPERTY_NAME
        XL_ANIMATION_PROPERTY_OPEN
        XL_ANIMATION_PROPERTY_COUNT

    const char* xl_animation_property_name[]
    const char* xl_animation_property_type[]

    void xl_animation_set_int(xl_animation_t*, xl_animation_property_t, int)
    int xl_animation_get_int(xl_animation_t*, xl_animation_property_t)

    void xl_animation_set_dbl(xl_animation_t*, xl_animation_property_t, double)
    double xl_animation_get_dbl(xl_animation_t*, xl_animation_property_t)

    void xl_animation_set_str(xl_animation_t*, xl_animation_property_t, const char*)
    const char* xl_animation_get_str(xl_animation_t*, xl_animation_property_t)

    void xl_animation_set_tex(xl_animation_t*, xl_animation_property_t, xl_texture_t*)
    xl_texture_t* xl_animation_get_tex(xl_animation_t*, xl_animation_property_t)

    void xl_animation_close(xl_animation_t* animation)

    void xl_animation_reset(xl_animation_t* animation)
    void xl_animation_reset_all()

    void xl_animation_update(xl_animation_t* animation, double dt)
    void xl_animation_update_all(double dt)

    void xl_animation_src_rect( xl_animation_t * animation, float * rect)
    void xl_animation_dst_rect( xl_animation_t * animation, float * rect,
                                const float pos[2], const float scale[2])

    void xl_animation_draw_ex(xl_animation_t* animation, float* dst_rect,
                                            double angle, float* center)

    void xl_animation_draw(xl_animation_t* animation, const float xy[2])

    xl_animation_t* xl_animation_load(xl_window_t* window, const char* filename,
                                            int frame_width, int frame_height)

    xl_animation_t* xl_animation_load_ex(xl_window_t* window, const char* filename,
                        int frame_width, int frame_height, ae_image_error_t* error)

    size_t xl_animation_count_all()
    void xl_animation_list_all(xl_animation_t** animations)

    void xl_animation_print_all()
    void xl_animation_close_all()

    # ==========================================================================
    # ~ [ timer objects ]
    # ==========================================================================

    xl_clock_t* xl_clock_create() # init & clone
    xl_clock_t* xl_clock_copy(xl_clock_t* clock)

    size_t xl_clock_buffer_size(xl_clock_t*) # serialization

    void xl_clock_buffer_save(u8* outbuf, xl_clock_t *clock)
    xl_clock_t* xl_clock_buffer_load(u8* buf, size_t length)

    ctypedef enum xl_clock_property_t:
        XL_CLOCK_PROPERTY_TOTAL
        XL_CLOCK_PROPERTY_ID
        XL_CLOCK_PROPERTY_NUM_TIMERS
        XL_CLOCK_PROPERTY_DT
        XL_CLOCK_PROPERTY_FPS
        XL_CLOCK_PROPERTY_AUTO_UPDATE
        XL_CLOCK_PROPERTY_PAUSED
        XL_CLOCK_PROPERTY_STATUS
        XL_CLOCK_PROPERTY_NAME
        XL_CLOCK_PROPERTY_OPEN
        XL_CLOCK_PROPERTY_COUNT

    const char* xl_clock_property_name[]
    const char* xl_clock_property_type[]

    void xl_clock_set_int(xl_clock_t*, xl_clock_property_t, int)
    int xl_clock_get_int(xl_clock_t*, xl_clock_property_t)

    void xl_clock_set_dbl(xl_clock_t*, xl_clock_property_t, double)
    double xl_clock_get_dbl(xl_clock_t*, xl_clock_property_t)

    void xl_clock_set_str(xl_clock_t*, xl_clock_property_t, const char*)
    const char* xl_clock_get_str(xl_clock_t*, xl_clock_property_t)

    void xl_clock_close(xl_clock_t* clock)

    void xl_clock_update(xl_clock_t* clock, double dt)
    void xl_clock_update_all(double dt) # tick timers

    void xl_clock_add_timer(xl_clock_t* clock, const char* name, double seconds, int repeat)

    void xl_clock_remove_timer(xl_clock_t* clock, const char* name)
    void xl_clock_remove_all_timers(xl_clock_t* clock)

    int xl_clock_get_timer(xl_clock_t* clock, const char* name, double* current,
                                    double* seconds, int* paused, int* repeats)

    void xl_clock_set_timer_current(xl_clock_t* clock, const char* name, double value)
    void xl_clock_set_timer_seconds(xl_clock_t* clock, const char* name, double value)

    void xl_clock_set_timer_paused(xl_clock_t* clock, const char* name, int value)
    void xl_clock_set_timer_repeat(xl_clock_t* clock, const char* name, int value)

    void xl_clock_set_timer_name(xl_clock_t* clock, const char* old_name,
                                                    const char* new_name)

    char** xl_clock_copy_timer_names(xl_clock_t* clock)
    void xl_clock_free_timer_names(xl_clock_t* clock, char** names)

    size_t xl_clock_count_all()
    void xl_clock_list_all(xl_clock_t** clocks)

    void xl_clock_print_all()
    void xl_clock_close_all()

    # ==========================================================================
    # ~ [ timed events ]
    # ==========================================================================

    void xl_timer_register(const char* tm_name, double seconds, int repeat)
    void xl_timer_unregister(const char* name)
    int  xl_timer_get(const char* n, double* cur, double* sec, int* repeat)
    void xl_timer_set_repeat(const char* name, int repeat)

    # ==========================================================================
    # ~ [ event handling ]
    # ==========================================================================

    ctypedef enum xl_event_type_t:
        XL_EVENT_NOTHING
        XL_EVENT_QUIT
        XL_EVENT_WINDOW_CLOSE
        XL_EVENT_WINDOW_MOVE
        XL_EVENT_WINDOW_RESIZE
        XL_EVENT_WINDOW_VISIBILITY_CHANGE
        XL_EVENT_WINDOW_REDRAW
        XL_EVENT_WINDOW_GAIN_FOCUS
        XL_EVENT_WINDOW_LOSE_FOCUS
        XL_EVENT_WINDOW_MOUSE_ENTER
        XL_EVENT_WINDOW_MOUSE_LEAVE
        XL_EVENT_MUSIC_FINISHED
        XL_EVENT_SOUND_FINISHED
        XL_EVENT_ANIMATION_FINISHED
        XL_EVENT_KEYBOARD_INSERT
        XL_EVENT_KEYBOARD_REMOVE
        XL_EVENT_KEYBOARD_KEY
        XL_EVENT_MOUSE_INSERT
        XL_EVENT_MOUSE_REMOVE
        XL_EVENT_MOUSE_BUTTON
        XL_EVENT_MOUSE_WHEEL
        XL_EVENT_MOUSE_MOTION
        XL_EVENT_CONTROLLER_INSERT
        XL_EVENT_CONTROLLER_REMOVE
        XL_EVENT_CONTROLLER_BUTTON
        XL_EVENT_CONTROLLER_TRIGGER
        XL_EVENT_CONTROLLER_STICK
        XL_EVENT_TIMER
        XL_EVENT_LONG_FRAME
        XL_EVENT_COUNT

    const char* xl_event_type_name[]

    # NOTE: these aren't real types (see the comment below re: anon union hack)

    ctypedef struct _xl_window_event_t:
        xl_window_t* window

    ctypedef struct _xl_window_mouse_event_t:
        xl_window_t* window
        xl_mouse_t* mouse

    ctypedef struct _xl_window_move_event_t:
        xl_window_t* window
        int x, y

    ctypedef struct _xl_window_resize_event_t:
        xl_window_t* window
        int width, height

    ctypedef struct _xl_window_visibility_change_event_t:
        xl_window_t* window
        int visible

    ctypedef struct _xl_sound_event_t:
        xl_sound_t* sound

    ctypedef struct _xl_animation_event_t:
        xl_animation_t* animation

    ctypedef struct _xl_keyboard_event_t:
        xl_keyboard_t* keyboard

    ctypedef struct _xl_keyboard_key_event_t:
        xl_keyboard_t* keyboard
        xl_keyboard_mod_bit_t mods
        xl_keyboard_key_index_t key
        int pressed

    ctypedef struct _xl_mouse_event_t:
        xl_mouse_t* mouse

    ctypedef struct _xl_mouse_button_event_t:
        xl_mouse_t* mouse
        xl_mouse_button_index_t button
        int pressed

    ctypedef struct _xl_mouse_wheel_event_t:
        xl_mouse_t* mouse
        int x, y

    ctypedef struct _xl_mouse_motion_event_t:
        xl_mouse_t* mouse
        xl_window_t* window
        xl_mouse_button_bit_t buttons
        double x, y, dx, dy

    ctypedef struct _xl_controller_event_t:
        xl_controller_t* controller

    ctypedef struct _xl_controller_button_event_t:
        xl_controller_t* controller
        xl_controller_button_index_t button
        int pressed

    ctypedef struct _xl_controller_trigger_event_t:
        xl_controller_t* controller
        char which
        double value

    ctypedef struct _xl_controller_stick_event_t:
        xl_controller_t* controller
        char which
        double magnitude, angle, x, y

    ctypedef struct _xl_timer_event_t:
        xl_clock_t* clock
        char* name
        double seconds
        int repeat

    ctypedef struct _xl_long_frame_event_t:
        double dt

    ctypedef struct xl_event_t:
        xl_event_type_t type

        # these are all members of an anonymous union. cython doesn't know this,
        # and cython also doesn't support anonymous unions... hence this hack.

        _xl_window_event_t                      as_window_close
        _xl_window_move_event_t                 as_window_move
        _xl_window_resize_event_t               as_window_resize
        _xl_window_visibility_change_event_t    as_window_visibility_change
        _xl_window_event_t                      as_window_redraw
        _xl_window_event_t                      as_window_gain_focus
        _xl_window_event_t                      as_window_lose_focus
        _xl_window_mouse_event_t                as_window_mouse_enter
        _xl_window_mouse_event_t                as_window_mouse_leave
        _xl_sound_event_t                       as_sound_finished
        _xl_animation_event_t                   as_animation_finished
        _xl_keyboard_event_t                    as_keyboard_insert
        _xl_keyboard_event_t                    as_keyboard_remove
        _xl_keyboard_key_event_t                as_keyboard_key
        _xl_mouse_event_t                       as_mouse_insert
        _xl_mouse_event_t                       as_mouse_remove
        _xl_mouse_button_event_t                as_mouse_button
        _xl_mouse_wheel_event_t                 as_mouse_wheel
        _xl_mouse_motion_event_t                as_mouse_motion
        _xl_controller_event_t                  as_controller_insert
        _xl_controller_event_t                  as_controller_remove
        _xl_controller_button_event_t           as_controller_button
        _xl_controller_trigger_event_t          as_controller_trigger
        _xl_controller_stick_event_t            as_controller_stick
        _xl_timer_event_t                       as_timer
        _xl_long_frame_event_t                  as_long_frame

    ctypedef void (*xl_event_handler_t)(xl_event_t* event, void* context)

    void xl_event_get_handler(xl_event_handler_t* handler, void** context)
    void xl_event_set_handler(xl_event_handler_t handler, void* context)

    size_t xl_event_count_pending()
    int xl_event_poll(xl_event_t* event, int wait)

def early_init(bint audio=True):
    """
    Take the initialization lag hit before opening windows and/or playing audio.
    Otherwise, XL init is performed on window open, and audio init on playback.
    """
    xl_init()
    if audio: xl_audio_init()

def implementation():
    """
    Identify the underlying platform layer, for 'safer' game-specific hacks.
    """
    cdef bytes video = xl_implementation() # implicitly cast pointers
    cdef bytes audio = xl_audio_implementation() # separate sfx layer

    if sys.version_info.major > 2:
        return (video.decode(), audio.decode()) # convert to unicode
    else:
        return (video, audio) # use oldschool python 2 ascii strings

# ==============================================================================
# ~ [ generic objects ]
# ==============================================================================

cdef class Object:
    """
    Optionally garbage-collected interface for any XL object. Not a base class.
    """
    cdef public bint collect
    cdef void * ptr

    def __init__(self, size_t reference=0, bint collect=False):
        self.collect = collect
        self.ptr = <void*>reference

    def __dealloc__(self):
        if self.collect and self.open: self.close()

    def __repr__(self):
        if self.open:
            return ('Collected' if self.collect else 'Wrapped') + repr(self.cast())
        else:
            return '{}(unknown)'.format(self.__class__.__name__)

    def __hash__(self):
        return hash(self.address())

    def __richcmp__(self, object other, int op):
        if   op == 0: return self.address() <  other.address()
        elif op == 1: return self.address() <= other.address()
        elif op == 2: return self.address() == other.address()
        elif op == 3: return self.address() != other.address()
        elif op == 4: return self.address() >  other.address()
        elif op == 5: return self.address() >= other.address()

        else: assert 0

    def __nonzero__(self):
        return self.open

    def __reduce__(self):
        raise TypeError('cannot pickle {}'.format(self))

    def __copy__(self):
        raise TypeError('cannot copy {}'.format(self))

    def __getattr__(self, key):
        if self.open:
            return getattr(self.cast(), key)
        else:
            raise AttributeError("'{}' object has no attribute '{}'" \
                                        .format(str(type(self)), key))

    def __setattr__(self, key, val):
        if self.open:
            setattr(self.cast(), key, val)
        else:
            raise AttributeError("'{}' object has no attribute '{}'" \
                                        .format(str(type(self)), key))

    @staticmethod
    def count_all(): return xl_object_count_all()

    @classmethod
    def list_all(cls, bint cast=True):
        """
        Gather references to all open, active, valid objects in a single list.
        """
        cdef void* xl_objects[8192]
        cdef int i
        cdef list objects = []

        if xl_object_count_all() > 8192:
            raise MemoryError("too many open xl objects for temp")

        xl_object_list_all(xl_objects)

        for i in range(<int>xl_object_count_all()):
            objects.append(cls(reference = <size_t>xl_objects[i]))

            if cast: objects[i] = objects[i].cast()

        return objects

    @staticmethod
    def print_all(): xl_object_print_all()

    @staticmethod
    def close_all(): xl_object_close_all()

    property open:
        def __get__(self):
            return xl_object_type(self.ptr) != XL_OBJECT_TYPE_UNKNOWN

    def address(self):
        return <size_t>self.ptr

    def cast(self):
        """
        Get self converted to the type of object it wraps. This is slow!!!
        """
        cdef xl_object_type_t object_type = xl_object_type(self.ptr) # enum
        cdef bytes name = xl_object_type_short_name[< size_t >object_type]

        cdef str nstr # TODO: move all string code after unknown detection

        if object_type == XL_OBJECT_TYPE_UNKNOWN:
            return self

        # XXX: is there a way to detect version num without calling python?
        if sys.version_info.major > 2:
            nstr = name.decode() # convert ascii type name to UTF for py3k
        else:
            nstr = <str>name # keep the oldschool byte string for python 2

        return globals()[nstr.replace('_', ' ').title().replace(' ', '')] \
                                            (reference = <size_t>self.ptr)

def ObjectFrom(object obj, bint collect=False):
    """
    Cheesy, easy grammar for the lazy typist. This would have been a class
    method, but 'from' is a keyword in Python for imports and generators.
    """
    return Object(obj.address(), collect)

def AutoObject(object obj):
    """
    Convenience ctor for locals, ex. `t = AutoObject(Texture().load(...))`.
    """
    return Object(obj.address(), True)

# ==============================================================================
# ~ [ window management ]
# ==============================================================================

cdef class Window:
    """
    A rendering context with an optional resolution-independent 2D renderer.
    Contains all textures and fonts that are valid to render in this window.
    """
    cdef xl_window_t* window

    def __init__(self, **kwargs):
        """
        Note that also pertains to the rest of this system: `reference` is a
        pointer value for this object, which can be retrieved with address().

        If a reference is not provided, a new window is constructed with the
        properties given by a set of keyword arguments (e.g. bordered=False).
        """
        if 'reference' in kwargs:
            self.window = <xl_window_t*>(<size_t>kwargs['reference'])
        else:
            # create default window, modify properties, and make it visible
            self.window = xl_window_create(0)

            for key, val in kwargs.items():
                setattr(self, key, val)

            # allow invisible windows to be created here for whatever reason
            if not kwargs.get('visible', True): return

            # TODO: flush the window visibility change event this generates
            xl_window_set_int(self.window, XL_WINDOW_PROPERTY_VISIBLE, 1)

    def __repr__(self):
        return "{}({})".format(self.__class__.__name__, self.status)

    def __hash__(self):
        return hash(self.address())

    def __richcmp__(self, Window other, int op):
        if   op == 0: return self.address() <  other.address()
        elif op == 1: return self.address() <= other.address()
        elif op == 2: return self.address() == other.address()
        elif op == 3: return self.address() != other.address()
        elif op == 4: return self.address() >  other.address()
        elif op == 5: return self.address() >= other.address()

        else: assert 0

    def __nonzero__(self):
        return xl_window_get_int(self.window, XL_WINDOW_PROPERTY_OPEN)

    def __reduce__(self):
        raise TypeError('cannot pickle {}'.format(self))

    def __copy__(self):
        raise TypeError('cannot copy {}'.format(self))

    @staticmethod
    def count_all(): return xl_window_count_all()

    @classmethod
    def list_all(cls):
        """
        Gather references to all open windows in a single list.
        """
        cdef xl_window_t* windows[256]
        cdef int i
        cdef list objects = []

        if xl_window_count_all() > 256:
            raise MemoryError("too many open windows for temp")

        xl_window_list_all(windows)

        for i in range(<int>xl_window_count_all()):
            objects.append(cls(reference = <size_t>windows[i]))

        return objects

    @staticmethod
    def print_all(): xl_window_print_all()

    @staticmethod
    def close_all(): xl_window_close_all()

    @classmethod
    def get_primary(cls):
        """
        Get the main application window (usually the first one).
        """
        return cls(reference = <size_t>xl_primary_window())

    def count_textures(self):
        return xl_window_count_textures(self.window)

    def list_textures(self, object cls=Texture):
        """
        Get a list of all active textures bound to this GL context.
        """
        cdef xl_texture_t* textures[8192]
        cdef int i
        cdef list objects = []

        if xl_window_count_textures(self.window) > 8192:
            raise MemoryError("too many open textures for temp")

        xl_window_list_textures(self.window, textures)

        for i in range(<int>xl_window_count_textures(self.window)):
            objects.append(cls(reference = <size_t>textures[i]))

        return objects

    def print_textures(self):
        xl_window_print_textures(self.window); return self

    def close_textures(self):
        xl_window_close_textures(self.window); return self

    def count_fonts(self):
        return xl_window_count_fonts(self.window)

    def list_fonts(self, object cls=Font):
        """
        Get a list of all open fonts bound to this GL context.
        """
        cdef xl_font_t* fonts[1024]
        cdef int i
        cdef list objects = []

        if xl_window_count_fonts(self.window) > 1024:
            raise MemoryError("too many open fonts for temp")

        xl_window_list_fonts(self.window, fonts)

        for i in range(<int>xl_window_count_fonts(self.window)):
            objects.append(cls(reference = <size_t>fonts[i]))

        return objects

    def print_fonts(self):
        xl_window_print_fonts(self.window); return self

    def close_fonts(self):
        xl_window_close_fonts(self.window); return self

    property id:
        def __get__(self):
            return xl_window_get_int(self.window, XL_WINDOW_PROPERTY_ID)

    property rect:
        def __get__(self):
            return IntRect(self.x, self.y, self.width, self.height)

        def __set__(self, object value):
            self.x, self.y, self.width, self.height = value

    property x:
        def __get__(self):
            return xl_window_get_int(self.window, XL_WINDOW_PROPERTY_X)

        def __set__(self, int value):
            xl_window_set_int(self.window, XL_WINDOW_PROPERTY_X, value)

    property y:
        def __get__(self):
            return xl_window_get_int(self.window, XL_WINDOW_PROPERTY_Y)

        def __set__(self, int value):
            xl_window_set_int(self.window, XL_WINDOW_PROPERTY_Y, value)

    property width:
        def __get__(self):
            return xl_window_get_int(self.window, XL_WINDOW_PROPERTY_WIDTH)

        def __set__(self, int value):
            xl_window_set_int(self.window, XL_WINDOW_PROPERTY_WIDTH, value)

    property height:
        def __get__(self):
            return xl_window_get_int(self.window, XL_WINDOW_PROPERTY_HEIGHT)

        def __set__(self, int value):
            xl_window_set_int(self.window, XL_WINDOW_PROPERTY_HEIGHT, value)

    property size:
        def __get__(self):
            return (self.width, self.height)

        def __set__(self, object value):
            self.width, self.height = value

    property pos:
        def __get__(self):
            return (self.x, self.y)

        def __set__(self, object value):
            self.x, self.y = value

    property display_rect:
        def __get__(self):
            cdef IntRect r = IntRect()

            r.rect[0] = xl_window_get_int(self.window, XL_WINDOW_PROPERTY_DISPLAY_X)
            r.rect[1] = xl_window_get_int(self.window, XL_WINDOW_PROPERTY_DISPLAY_Y)

            r.rect[2] = xl_window_get_int(self.window, XL_WINDOW_PROPERTY_DISPLAY_WIDTH )
            r.rect[3] = xl_window_get_int(self.window, XL_WINDOW_PROPERTY_DISPLAY_HEIGHT)

            return r

    property display_x:
        def __get__(self):
            return xl_window_get_int(self.window, XL_WINDOW_PROPERTY_DISPLAY_X)

    property display_y:
        def __get__(self):
            return xl_window_get_int(self.window, XL_WINDOW_PROPERTY_DISPLAY_Y)

    property display_width:
        def __get__(self):
            return xl_window_get_int(self.window, XL_WINDOW_PROPERTY_DISPLAY_WIDTH)

    property display_height:
        def __get__(self):
            return xl_window_get_int(self.window, XL_WINDOW_PROPERTY_DISPLAY_HEIGHT)

    property display_size:
        def __get__(self):
            return (self.display_width, self.display_height)

    property display_pos:
        def __get__(self):
            return (self.display_x, self.display_y)

    property render_width:
        def __get__(self):
            return xl_window_get_int(self.window, XL_WINDOW_PROPERTY_RENDER_WIDTH)

        def __set__(self, int value):
            xl_window_set_int(self.window, XL_WINDOW_PROPERTY_RENDER_WIDTH, value)

    property render_height:
        def __get__(self):
            return xl_window_get_int(self.window, XL_WINDOW_PROPERTY_RENDER_HEIGHT)

        def __set__(self, int value):
            xl_window_set_int(self.window, XL_WINDOW_PROPERTY_RENDER_HEIGHT, value)

    property render_size:
        def __get__(self):
            return (self.render_width, self.render_height)

        def __set__(self, object value):
            self.render_width, self.render_height = value

    property high_quality_textures:
        def __get__(self):
            return xl_window_get_int(self.window, XL_WINDOW_PROPERTY_HIGH_QUALITY_TEXTURES)

        def __set__(self, bint value):
            xl_window_set_int(self.window, XL_WINDOW_PROPERTY_HIGH_QUALITY_TEXTURES, value)

    property copy_textures:
        def __get__(self):
            return xl_window_get_int(self.window, XL_WINDOW_PROPERTY_COPY_TEXTURES)

        def __set__(self, bint value):
            xl_window_set_int(self.window, XL_WINDOW_PROPERTY_COPY_TEXTURES, value)

    property opengl:
        def __get__(self):
            return xl_window_get_int(self.window, XL_WINDOW_PROPERTY_OPENGL)

    property fullscreen:
        def __get__(self):
            return xl_window_get_int(self.window, XL_WINDOW_PROPERTY_FULLSCREEN)

        def __set__(self, bint value):
            xl_window_set_int(self.window, XL_WINDOW_PROPERTY_FULLSCREEN, value)

    property bordered:
        def __get__(self):
            return xl_window_get_int(self.window, XL_WINDOW_PROPERTY_BORDERED)

        def __set__(self, bint value):
            xl_window_set_int(self.window, XL_WINDOW_PROPERTY_BORDERED, value)

    property visible:
        def __get__(self):
            return xl_window_get_int(self.window, XL_WINDOW_PROPERTY_VISIBLE)

        def __set__(self, bint value):
            xl_window_set_int(self.window, XL_WINDOW_PROPERTY_VISIBLE, value)

    property resizable:
        def __get__(self):
            return xl_window_get_int(self.window, XL_WINDOW_PROPERTY_RESIZABLE)

        def __set__(self, bint value):
            xl_window_set_int(self.window, XL_WINDOW_PROPERTY_RESIZABLE, value)

    property active:
        def __get__(self):
            return xl_window_get_int(self.window, XL_WINDOW_PROPERTY_ACTIVE)

        def __set__(self, bint value):
            xl_window_set_int(self.window, XL_WINDOW_PROPERTY_ACTIVE, value)

    property grabbed:
        def __get__(self):
            return xl_window_get_int(self.window, XL_WINDOW_PROPERTY_GRABBED)

        def __set__(self, bint value):
            xl_window_set_int(self.window, XL_WINDOW_PROPERTY_GRABBED, value)

    property vsync:
        def __get__(self):
            return xl_window_get_int(self.window, XL_WINDOW_PROPERTY_VSYNC)

        def __set__(self, bint value):
            xl_window_set_int(self.window, XL_WINDOW_PROPERTY_VSYNC, value)

    property primary:
        def __get__(self):
            return xl_window_get_int(self.window, XL_WINDOW_PROPERTY_PRIMARY)

    property open:
        def __get__(self):
            return xl_window_get_int(self.window, XL_WINDOW_PROPERTY_OPEN)

        def __set__(self, bint value):
            xl_window_set_int(self.window, XL_WINDOW_PROPERTY_OPEN, value)

    property status:
        def __get__(self):
            cdef bytes s = xl_window_get_str(self.window, XL_WINDOW_PROPERTY_STATUS)
            return s.decode() if sys.version_info.major > 2 else s

        def __set__(self, str value):
            cdef bytes string

            if sys.version_info.major > 2:
                string = <bytes>value.encode('utf-8')
            else:
                string = <bytes>value

            xl_window_set_str(self.window, XL_WINDOW_PROPERTY_STATUS, <char*>string)

    property title:
        def __get__(self):
            cdef bytes s = xl_window_get_str(self.window, XL_WINDOW_PROPERTY_TITLE)
            return s.decode() if sys.version_info.major > 2 else s

        def __set__(self, str value):
            cdef bytes string

            if sys.version_info.major > 2:
                string = <bytes>value.encode('utf-8')
            else:
                string = <bytes>value

            xl_window_set_str(self.window, XL_WINDOW_PROPERTY_TITLE, <char*>string)

    property name:
        def __get__(self):
            cdef bytes s = xl_window_get_str(self.window, XL_WINDOW_PROPERTY_NAME)
            return s.decode() if sys.version_info.major > 2 else s

        def __set__(self, str value):
            cdef bytes string

            if sys.version_info.major > 2:
                string = <bytes>value.encode('utf-8')
            else:
                string = <bytes>value

            xl_window_set_str(self.window, XL_WINDOW_PROPERTY_NAME, <char*>string)

    property icon:
        def __get__(self):
            raise NotImplementedError("TODO")

        def __set__(self, Image value):
            raise NotImplementedError("TODO")

    property opacity:
        def __get__(self):
            return xl_window_get_flt(self.window, XL_WINDOW_PROPERTY_OPACITY)

        def __set__(self, float value):
            xl_window_set_flt(self.window, XL_WINDOW_PROPERTY_OPACITY, value)

    property sdl_window:
        def __get__(self):
            return <size_t>xl_window_get_ptr(self.window, XL_WINDOW_PROPERTY_SDL_WINDOW)

    property sdl_renderer:
        def __get__(self):
            return <size_t>xl_window_get_ptr(self.window, XL_WINDOW_PROPERTY_SDL_RENDERER)

    property sdl_renderer_info:
        def __get__(self):
            return <size_t>xl_window_get_ptr(self.window, XL_WINDOW_PROPERTY_SDL_RENDERER_INFO)

    property sdl_gl_context:
        def __get__(self):
            return <size_t>xl_window_get_ptr(self.window, XL_WINDOW_PROPERTY_SDL_GL_CONTEXT)

    property driver:
        def __get__(self):
            cdef bytes b = xl_window_get_str(self.window, XL_WINDOW_PROPERTY_DRIVER)
            return b.decode() if sys.version_info.major > 2 else b

    property native_display:
        def __get__(self):
            return <size_t>xl_window_get_ptr(self.window, XL_WINDOW_PROPERTY_NATIVE_DISPLAY)

    property native_window:
        def __get__(self):
            return <size_t>xl_window_get_ptr(self.window, XL_WINDOW_PROPERTY_NATIVE_WINDOW)

    property win32_window:
        def __get__(self):
            return <size_t>xl_window_get_ptr(self.window, XL_WINDOW_PROPERTY_WIN32_WINDOW)

    property win32_hdc:
        def __get__(self):
            return <size_t>xl_window_get_ptr(self.window, XL_WINDOW_PROPERTY_WIN32_HDC)

    property win32_hinstance:
        def __get__(self):
            return <size_t>xl_window_get_ptr(self.window, XL_WINDOW_PROPERTY_WIN32_HINSTANCE)

    property winrt_window:
        def __get__(self):
            return <size_t>xl_window_get_ptr(self.window, XL_WINDOW_PROPERTY_WINRT_WINDOW)

    property x11_display:
        def __get__(self):
            return <size_t>xl_window_get_ptr(self.window, XL_WINDOW_PROPERTY_X11_DISPLAY)

    property x11_window:
        def __get__(self):
            return <size_t>xl_window_get_ptr(self.window, XL_WINDOW_PROPERTY_X11_WINDOW)

    property directfb_interface:
        def __get__(self):
            return <size_t>xl_window_get_ptr(self.window, XL_WINDOW_PROPERTY_DIRECTFB_INTERFACE)

    property directfb_window:
        def __get__(self):
            return <size_t>xl_window_get_ptr(self.window, XL_WINDOW_PROPERTY_DIRECTFB_WINDOW)

    property directfb_surface:
        def __get__(self):
            return <size_t>xl_window_get_ptr(self.window, XL_WINDOW_PROPERTY_DIRECTFB_SURFACE)

    property cocoa_window:
        def __get__(self):
            return <size_t>xl_window_get_ptr(self.window, XL_WINDOW_PROPERTY_COCOA_WINDOW)

    property uikit_window:
        def __get__(self):
            return <size_t>xl_window_get_ptr(self.window, XL_WINDOW_PROPERTY_UIKIT_WINDOW)

    property uikit_framebuffer:
        def __get__(self):
            return <size_t>xl_window_get_ptr(self.window, XL_WINDOW_PROPERTY_UIKIT_FRAMEBUFFER)

    property uikit_colorbuffer:
        def __get__(self):
            return <size_t>xl_window_get_ptr(self.window, XL_WINDOW_PROPERTY_UIKIT_COLORBUFFER)

    property uikit_resolve_framebuffer:
        def __get__(self):
            return <size_t>xl_window_get_ptr(self.window, XL_WINDOW_PROPERTY_UIKIT_RESOLVE_FRAMEBUFFER)

    property wayland_display:
        def __get__(self):
            return <size_t>xl_window_get_ptr(self.window, XL_WINDOW_PROPERTY_WAYLAND_DISPLAY)

    property wayland_surface:
        def __get__(self):
            return <size_t>xl_window_get_ptr(self.window, XL_WINDOW_PROPERTY_WAYLAND_SURFACE)

    property wayland_shell_surface:
        def __get__(self):
            return <size_t>xl_window_get_ptr(self.window, XL_WINDOW_PROPERTY_WAYLAND_SHELL_SURFACE)

    property mir_connection:
        def __get__(self):
            return <size_t>xl_window_get_ptr(self.window, XL_WINDOW_PROPERTY_MIR_CONNECTION)

    property mir_surface:
        def __get__(self):
            return <size_t>xl_window_get_ptr(self.window, XL_WINDOW_PROPERTY_MIR_SURFACE)

    property android_window:
        def __get__(self):
            return <size_t>xl_window_get_ptr(self.window, XL_WINDOW_PROPERTY_ANDROID_WINDOW)

    property android_surface:
        def __get__(self):
            return <size_t>xl_window_get_ptr(self.window, XL_WINDOW_PROPERTY_ANDROID_SURFACE)

    property vivante_display:
        def __get__(self):
            return <size_t>xl_window_get_ptr(self.window, XL_WINDOW_PROPERTY_VIVANTE_DISPLAY)

    property vivante_window:
        def __get__(self):
            return <size_t>xl_window_get_ptr(self.window, XL_WINDOW_PROPERTY_VIVANTE_WINDOW)

    def address(self):
        return <size_t>self.window

    def cast(self):
        return self

    def close(self):
        xl_window_close(self.window); return self

    def clear(self, float r=0, float g=0, float b=0):
        xl_window_clear(self.window, r, g, b); return self

    def flip(self):
        xl_window_flip(self.window); return self

    def screenshot(self):
        """
        Copy the contents of the window to an image. This may take a while!
        """
        cdef Image image = Image()

        xl_window_screenshot(self.window, &image.image)
        return image

    def draw_rect(self, FloatRect rect=None, Vec4 color=None, double angle=0.0,
                                        Vec2 center=None, bint outline=False):
        """
        Draw a colored rectangle, with an optional rotation and outline mode.
        """
        xl_draw_rect_ex(self.window,
                        NULL if rect is None else rect.rect,
                        NULL if color is None else color.v,
                        angle,
                        NULL if center is None else center.v,
                        outline)
        return self

    def draw_points(self, Array points, Vec4 color=None):
        """
        Draw an array of 2D-dimensional points / particles as single pixels.
        """
        xl_draw_points( self.window,
                        <float*>points.array.data,
                        points.array.size / sizeof(float[2]),
                        NULL if color is None else color.v)
        return self

    def draw_point(self, Vec2 point, Vec4 color=None):
        """
        Draw a single pixel onscreen. Batched calls are obviously much faster.
        """
        xl_draw_point(self.window, point.v, NULL if color is None else color.v)
        return self

    def draw_line(self, Vec2 a, Vec2 b, Vec4 color=None):
        """
        Draw a single translucent 1-pixel line segment from point A to point B.
        """
        xl_draw_line(self.window, a.v, b.v, NULL if color is None else color.v)
        return self

    def draw_curve(self, Vec2 a, Vec2 b, Vec4 color=None, str mode='cubic_inout',
                                                        size_t num_divisions=24):
        """
        Draw simple bezier curve with a given easing mode (see aegame.exm modes).
        """
        cdef bytes b_mode

        if sys.version_info.major > 2:
            b_mode = <bytes>mode.encode('utf-8')
        else:
            b_mode = <bytes>mode

        xl_draw_curve(self.window, a.v, b.v, NULL if color is None else color.v,
                    ae_ease_mode_from_short_name(<char *>b_mode), num_divisions)

        return self

    def draw_circle(self, Circle circle, Vec4 color=None,
            bint outline=False, size_t num_divisions=24):
        """
        Draw a circle (num_division is the straight segment count in the circle).
        """
        xl_draw_circle(self.window, circle.c.v, circle.r, # handle None?
            NULL if color is None else color.v, outline, num_divisions)

        return self

    def draw_triangle(self, Vec2 a, Vec2 b, Vec2 c, Vec4 color=None, bint outline=False):
        """
        Draw a triangle, either filled or 1-pixel outlined.
        """
        xl_draw_triangle(self.window, a.v, b.v, c.v, NULL if color is None else color.v,
                                                                                outline)
        return self

    def run(self, object initial_state):
        """
        Execute an application using a stack-like state machine. Each application
        state (object of any type) can contain the following optional properties:

            - on_enter(window) method for when the state is brought to stack top
            - on_leave(window) method for when the state is popped (or buried)

            - queued_state is the next state, that we want to push onto the stack
            - has_exit indicates that we want to finish this state and remove it

            - update(dt) method for logic (entity physics, AI, simulation, etc.)
            - draw(window) for rendering (separate from update for pause menus)

        States can also have event handling methods (i.e. on_controller_button).
        See xl.event.poll() for a listing of the various event handler methods.
        """
        # TODO: this executes in a stack-like manner, which is best for programs
        # like games that want to push and pop pause menus etc - create an option
        # to run in a queue-like manner for slideshow programs and other exotica.
        cdef list state_stack = []

        # Don't call activation code on the initial state if the window is invalid.
        if not self.open: return self

        # Reset the frame delta timer to prevent the first frame from being long.
        ae_frame_delta()

        def push_state(object state):
            """
            Push a queued state onto the application stack and activate it.
            """
            cdef bytes state_repr

            if sys.version_info.major > 2:
                state_repr = '{}'.format(state).encode('utf-8') # unicode
            else:
                state_repr = b'{}'.format(state) # oldschool ascii string

            if state_stack:
                if hasattr(state_stack[-1], 'on_leave'):
                    state_stack[-1].on_leave(self)

                state_stack[-1].queued_state = None

            ae_log_str('MISC', 'state push: %s', <const char*>state_repr)
            state_stack.append(state)

            if hasattr(state, 'on_enter'):
                state.on_enter(self)

        def pop_state():
            """
            Remove the top state from the application stack and deactivate it.
            """
            cdef bytes state_repr

            if sys.version_info.major > 2:
                state_repr = '{}'.format(state_stack[-1]).encode('utf-8')
            else:
                state_repr = b'{}'.format(state_stack[-1]) # utf or ascii

            if (hasattr(state_stack[-1], 'on_leave')):
                state_stack[-1].on_leave(self)

            ae_log_str('MISC', 'state pop: %s', <const char*>state_repr)
            state_stack.pop()

            if (state_stack and hasattr(state_stack[-1], 'on_enter')):
                state_stack[-1].on_enter(self)

        def emit_frame(double dt):
            """
            Run a single iteration of the game loop. Note that when the final frame
            has finished, the window framebuffer contents are not cleared to avoid
            a black flash if the user decides to do something else with the window.
            """
            # Filter out insane spikes (e.g. due to another process, or loading).
            if (dt > 0.1):
                ae_log_str('TIME', 'long frame time delta: %f seconds', dt)
                dt = 0.01

            while state_stack and getattr(state_stack[-1], 'has_exit', False):
                pop_state()

            if state_stack:
                # TODO: Flush the state stack if we encounter an unhandled on_quit
                # event (dispatch_all returns the events dispatched to a handler).
                # TODO: Paused/tool states (wait for events and don't update/draw).

                event.dispatch_all(state_stack[-1])

                # TODO: Allow users to pass a custom window clear color to run().
                self.clear()

                # NOTE: The decision to pass a window to draw() was controversial,
                # if a real controversy can exist within the mind of one person.
                # We (meaning I) should also consider the possibility of changing
                # these method names to on_update, on_draw etc. for consistency.
                # Take this to the ISO Committee on Issues Related to Yak Shaving.

                if hasattr(state_stack[-1], 'update'):
                    state_stack[-1].update(dt)

                if hasattr(state_stack[-1], 'draw'):
                    state_stack[-1].draw(self)

                self.flip()

                # TODO: Should we pop dead states from the top of the stack first?
                # Will the state stack ever grow large enough for this to matter?

                if getattr(state_stack[-1], 'queued_state', None):
                    push_state(state_stack[-1].queued_state)

        push_state(initial_state)

        while state_stack and self.open:
            emit_frame(ae_frame_delta())

        # If the window closes in the middle of execution, call all cleanup code.
        while state_stack: pop_state()

        return self

# ==============================================================================
# ~ [ texture renderer ]
# ==============================================================================

cdef class Texture:
    """
    An image resident in server (GPU) memory used for faster rendering than what
    can be accomplished with blitting. Can also be used as a "framebuffer" for
    a software renderer (in case you want weird low-res effects without shaders).
    """
    cdef xl_texture_t* texture

    def __init__(self, size_t reference=0):
        self.texture = <xl_texture_t*>reference

    def __repr__(self):
        return "{}({})".format(self.__class__.__name__, self.status)

    def __hash__(self):
        return hash(self.address())

    def __richcmp__(self, Texture other, int op):
        if   op == 0: return self.address() <  other.address()
        elif op == 1: return self.address() <= other.address()
        elif op == 2: return self.address() == other.address()
        elif op == 3: return self.address() != other.address()
        elif op == 4: return self.address() >  other.address()
        elif op == 5: return self.address() >= other.address()

        else: assert 0

    def __nonzero__(self):
        return xl_texture_get_int(self.texture, XL_TEXTURE_PROPERTY_OPEN)

    def __reduce__(self):
        raise TypeError('cannot pickle {}'.format(self))

    def __copy__(self):
        raise TypeError('cannot copy {}'.format(self))

    def __call__(self, *a, **k):
        return self.draw(*a, **k)

    @staticmethod
    def count_all(): return xl_texture_count_all()

    @classmethod
    def list_all(cls):
        """
        Gather references to all open, active, valid textures in a single list.
        """
        cdef xl_texture_t* textures[8192]
        cdef int i
        cdef list objects = []

        if xl_texture_count_all() > 8192:
            raise MemoryError("too many open textures for temp")

        xl_texture_list_all(textures)

        for i in range(<int>xl_texture_count_all()):
            objects.append(cls(reference = <size_t>textures[i]))

        return objects

    @staticmethod
    def print_all(): xl_texture_print_all()

    @staticmethod
    def close_all(): xl_texture_close_all()

    property id:
        def __get__(self):
            return xl_texture_get_int(self.texture, XL_TEXTURE_PROPERTY_ID)

    property width:
        def __get__(self):
            return xl_texture_get_int(self.texture, XL_TEXTURE_PROPERTY_WIDTH)

    property height:
        def __get__(self):
            return xl_texture_get_int(self.texture, XL_TEXTURE_PROPERTY_HEIGHT)

    property size:
        def __get__(self):
            return (self.width, self.height)

    property image:
        def __get__(self):
            cdef ae_image_t* c = xl_texture_get_img(self.texture, XL_TEXTURE_PROPERTY_IMAGE)
            cdef Image p = Image()

            # if we're not returning None (due to copy-on-upload being disabled), we must
            # make a copy of the image data for safe use with python's memory management.
            # this is the slow path you take by setting XL_TEXTURE_PROPERTY_COPY_ENABLED!

            if c != NULL:
                ae_image_copy(&p.image, c)
                return p

        def __set__(self, Image value):
            xl_texture_set_img(self.texture, XL_TEXTURE_PROPERTY_IMAGE, &value.image)

    property copy_enabled:
        def __get__(self):
            return xl_texture_get_int(self.texture, XL_TEXTURE_PROPERTY_COPY_ENABLED)

        def __set__(self, bint value):
            xl_texture_set_int(self.texture, XL_TEXTURE_PROPERTY_COPY_ENABLED, value)

    property draw_calls:
        def __get__(self):
            return xl_texture_get_int(self.texture, XL_TEXTURE_PROPERTY_DRAW_CALLS)

        def __set__(self, int value):
            xl_texture_set_int(self.texture, XL_TEXTURE_PROPERTY_DRAW_CALLS, value)

    property window:
        def __get__(self):
            return Window(reference = <size_t> xl_texture_get_ptr(
                        self.texture, XL_TEXTURE_PROPERTY_WINDOW))

    property status:
        def __get__(self):
            cdef bytes s = xl_texture_get_str(self.texture, XL_TEXTURE_PROPERTY_STATUS)
            return s.decode() if sys.version_info.major > 2 else s # convert to unicode

        def __set__(self, str value):
            cdef bytes string

            if sys.version_info.major > 2:
                string = <bytes>value.encode('utf-8')
            else:
                string = <bytes>value

            xl_texture_set_str(self.texture, XL_TEXTURE_PROPERTY_STATUS, <char*>string)

    property path:
        def __get__(self):
            cdef bytes s = xl_texture_get_str(self.texture, XL_TEXTURE_PROPERTY_PATH)
            return s.decode() if sys.version_info.major > 2 else s # convert to utf-8

        def __set__(self, str value):
            cdef bytes string

            if sys.version_info.major > 2:
                string = <bytes>value.encode('utf-8')
            else:
                string = <bytes>value

            xl_texture_set_str(self.texture, XL_TEXTURE_PROPERTY_PATH, <char*>string)

    property name:
        def __get__(self):
            cdef bytes s = xl_texture_get_str(self.texture, XL_TEXTURE_PROPERTY_NAME)
            return s.decode() if sys.version_info.major > 2 else s # convert to utf-8

        def __set__(self, str value):
            cdef bytes string

            if sys.version_info.major > 2:
                string = <bytes>value.encode('utf-8')
            else:
                string = <bytes>value

            xl_texture_set_str(self.texture, XL_TEXTURE_PROPERTY_NAME, <char*>string)

    property red:
        def __get__(self):
            return xl_texture_get_flt(self.texture, XL_TEXTURE_PROPERTY_RED)

        def __set__(self, float value):
            xl_texture_set_flt(self.texture, XL_TEXTURE_PROPERTY_RED, value)

    property green:
        def __get__(self):
            return xl_texture_get_flt(self.texture, XL_TEXTURE_PROPERTY_GREEN)

        def __set__(self, float value):
            xl_texture_set_flt(self.texture, XL_TEXTURE_PROPERTY_GREEN, value)

    property blue:
        def __get__(self):
            return xl_texture_get_flt(self.texture, XL_TEXTURE_PROPERTY_BLUE)

        def __set__(self, float value):
            xl_texture_set_flt(self.texture, XL_TEXTURE_PROPERTY_BLUE, value)

    property alpha:
        def __get__(self):
            return xl_texture_get_flt(self.texture, XL_TEXTURE_PROPERTY_ALPHA)

        def __set__(self, float value):
            xl_texture_set_flt(self.texture, XL_TEXTURE_PROPERTY_ALPHA, value)

    property rgb:
        def __get__(self):
            cdef void* c = xl_texture_get_ptr(self.texture, XL_TEXTURE_PROPERTY_RGB)
            cdef Vec3 p = Vec3()

            if c != NULL: vec3copy(p.v, <const float*>c)
            return p

        def __set__(self, Vec3 value):
            xl_texture_set_ptr(self.texture, XL_TEXTURE_PROPERTY_RGB, value.v)

    property rgba:
        def __get__(self):
            cdef void* c = xl_texture_get_ptr(self.texture, XL_TEXTURE_PROPERTY_RGBA)
            cdef Vec4 p = Vec4()

            if c != NULL: vec4copy(p.v, <const float*>c)
            return p

        def __set__(self, Vec4 value):
            xl_texture_set_ptr(self.texture, XL_TEXTURE_PROPERTY_RGBA, value.v)

    property high_quality:
        def __get__(self):
            return xl_texture_get_int(self.texture, XL_TEXTURE_PROPERTY_HIGH_QUALITY)

        def __set__(self, bint value):
            xl_texture_set_int(self.texture, XL_TEXTURE_PROPERTY_HIGH_QUALITY, value)

    property scale_filter:
        def __get__(self):
            cdef bytes s = xl_texture_get_str(self.texture, XL_TEXTURE_PROPERTY_SCALE_FILTER)
            return s.decode() if sys.version_info.major > 2 else s # convert char* to unicode

        def __set__(self, str value):
            cdef bytes string

            if sys.version_info.major > 2:
                string = <bytes>value.encode('utf-8')
            else:
                string = <bytes>value

            xl_texture_set_str(self.texture, XL_TEXTURE_PROPERTY_SCALE_FILTER, <char*>string)

    property subpixel:
        def __get__(self):
            return xl_texture_get_int(self.texture, XL_TEXTURE_PROPERTY_SUBPIXEL)

        def __set__(self, bint value):
            xl_texture_set_int(self.texture, XL_TEXTURE_PROPERTY_SUBPIXEL, value)

    property flip:
        def __get__(self):
            cdef bytes s = xl_texture_get_str(self.texture, XL_TEXTURE_PROPERTY_FLIP)
            return s.decode() if sys.version_info.major > 2 else s # convert to utf-8

        def __set__(self, str value):
            cdef bytes string

            if sys.version_info.major > 2:
                string = <bytes>value.encode('utf-8')
            else:
                string = <bytes>value

            xl_texture_set_str(self.texture, XL_TEXTURE_PROPERTY_FLIP, <char*>string)

    property open:
        def __get__(self):
            return xl_texture_get_int(self.texture, XL_TEXTURE_PROPERTY_OPEN)

        def __set__(self, bint value):
            xl_texture_set_int(self.texture, XL_TEXTURE_PROPERTY_OPEN, value)

    def address(self):
        return <size_t>self.texture

    def cast(self):
        return self

    def close(self):
        xl_texture_close(self.texture); return self

    def create(self, Window window, int width, int height, **kwargs):
        """
        Manually create a texture (set pixel data with the image property).
        """
        if not self.open:
            self.texture = xl_texture_create(window.window, width, height)

            # convenient way to set some texture attributes inline
            for key, val in kwargs.items(): setattr(self, key, val)

        return self

    def load_from_memory(self, Window window, size_t ptr, size_t length, **kwargs):
        """
        Load a compressed image file into a texture. Raises IOError if load fails.
        """
        cdef ae_image_error_t error = AE_IMAGE_NO_CODEC # stub default

        # convert ascii error message to unicode (for python 3 only)
        cdef bytes error_bstring

        if not self.open:
            self.texture = xl_texture_load_from_memory_ex(window.window,
                                            <void*>ptr, length, &error)

            if error != AE_IMAGE_SUCCESS:
                error_bstring = ae_image_error_message(error, NULL)

                if sys.version_info.major > 2:
                    raise IOError(error_bstring.decode())
                else:
                    raise IOError(error_bstring)

            # convenient way to set some texture attributes inline
            for key, val in kwargs.items(): setattr(self, key, val)

        return self

    def load_from_array(self, Window window, Array data, **kwargs):
        """
        Load a texture from an array, most likely a subview pointing to an archive slot.
        """
        return self.load_from_memory(window, data.address(), len(data), **kwargs)

    def load_from_bytes(self, Window window, bytes data, **kwargs):
        """
        Load a texture from a byte string, likely via open(filename, 'rb').read().
        """
        return self.load_from_memory(window, <size_t>(<char*>data), len(data), **kwargs)

    def load(self, Window window, str filename, **kwargs):
        """
        Load an image into a texture. Raises IOError if image loading fails.
        """
        cdef ae_image_error_t error = AE_IMAGE_NO_CODEC # default for stubs

        cdef bytes b_filename
        cdef bytes err_string

        # convert unicode filename to ascii in python 3, leave it otherwise
        if sys.version_info.major > 2:
            b_filename = <bytes>filename.encode('utf-8')
        else:
            b_filename = <bytes>filename

        if not self.open:
            self.texture = xl_texture_load_ex(window.window,
                                <char *>b_filename, &error)

            if error != AE_IMAGE_SUCCESS:
                err_string = ae_image_error_message(error, <char*>b_filename)

                if sys.version_info.major > 2:
                    raise IOError(err_string.decode()) # convert to unicode
                else:
                    raise IOError(err_string) # use oldschool ascii string

            # convenient way to set some texture attributes inline
            for key, val in kwargs.items(): setattr(self, key, val)

        return self

    def rect(self, Vec2 pos=Vec2(), Vec2 scale=Vec2(1.0, 1.0)):
        """
        Create a destination (or source) rect for rendering. Makes draw_ex easy.
        """
        cdef FloatRect r = FloatRect()

        r.rect[0] = pos.v[0]
        r.rect[1] = pos.v[1]

        r.rect[2] = xl_texture_get_flt(self.texture, XL_TEXTURE_PROPERTY_WIDTH )
        r.rect[3] = xl_texture_get_flt(self.texture, XL_TEXTURE_PROPERTY_HEIGHT)

        r.rect[2] *= scale.v[0]
        r.rect[3] *= scale.v[1]

        return r

    def draw_ex(self, FloatRect src_rect=None, FloatRect dst_rect=None,
                double angle=0.0, Vec2 center=None):
        """
        Draw the texture with optional clipping (src), rotation, and scale (dst).
        """
        xl_texture_draw_ex( self.texture, # NULL rects select entire area
                            NULL if src_rect is None else src_rect.rect,
                            NULL if dst_rect is None else dst_rect.rect,
                            angle, NULL if center is None else center.v)
        return self

    def draw(self, Vec2 pos=Vec2()):
        """
        Draw texture without clipping, rotation, or scaling (just translation).
        """
        xl_texture_draw(self.texture, pos.v); return self

# ==============================================================================
# ~ [ font renderer ]
# ==============================================================================

cdef class Font:
    """
    A TrueType font file used for rendering text to the screen or an image.
    """
    cdef xl_font_t* font

    def __init__(self, size_t reference=0):
        self.font = <xl_font_t*>reference

    def __repr__(self):
        return "{}({})".format(self.__class__.__name__, self.status)

    def __hash__(self):
        return hash(self.address())

    def __richcmp__(self, Font other, int op):
        if   op == 0: return self.address() <  other.address()
        elif op == 1: return self.address() <= other.address()
        elif op == 2: return self.address() == other.address()
        elif op == 3: return self.address() != other.address()
        elif op == 4: return self.address() >  other.address()
        elif op == 5: return self.address() >= other.address()

        else: assert 0

    def __nonzero__(self):
        return xl_font_get_int(self.font, XL_FONT_PROPERTY_OPEN)

    def __reduce__(self):
        raise TypeError('cannot pickle {}'.format(self))

    def __copy__(self):
        raise TypeError('cannot copy {}'.format(self))

    def __call__(self, *a, **k):
        return self.draw(*a, **k)

    @staticmethod
    def print_all(): return xl_font_print_all()

    @staticmethod
    def count_all(): return xl_font_count_all()

    @classmethod
    def list_all(cls):
        """
        Gather references to all open, active, valid fonts in a single list.
        """
        cdef xl_font_t* fonts[1024]
        cdef int i
        cdef list objects = []

        if xl_font_count_all() > 1024:
            raise MemoryError("too many open fonts for temp")

        xl_font_list_all(fonts)

        for i in range(<int>xl_font_count_all()):
            objects.append(cls(reference = <size_t>fonts[i]))

        return objects

    @staticmethod
    def close_all(): xl_font_close_all()

    property id:
        def __get__(self):
            return xl_font_get_int(self.font, XL_FONT_PROPERTY_ID)

    property point_size:
        def __get__(self):
            return xl_font_get_int(self.font, XL_FONT_PROPERTY_POINT_SIZE)

        def __set__(self, int value):
            xl_font_set_int(self.font, XL_FONT_PROPERTY_POINT_SIZE, value)

    property line_skip:
        def __get__(self):
            return xl_font_get_int(self.font, XL_FONT_PROPERTY_LINE_SKIP)

    property window:
        def __get__(self):
            return Window(reference=<size_t>xl_font_get_ptr(
                        self.font, XL_FONT_PROPERTY_WINDOW))

    property status:
        def __get__(self):
            cdef bytes s = xl_font_get_str(self.font, XL_FONT_PROPERTY_STATUS)
            return s.decode() if sys.version_info.major > 2 else s

        def __set__(self, str value):
            cdef bytes string

            if sys.version_info.major > 2:
                string = <bytes>value.encode('utf-8')
            else:
                string = <bytes>value

            xl_font_set_str(self.font, XL_FONT_PROPERTY_STATUS, <char*>string)

    property path:
        def __get__(self):
            cdef bytes s = xl_font_get_str(self.font, XL_FONT_PROPERTY_PATH)
            return s.decode() if sys.version_info.major > 2 else s

        def __set__(self, str value):
            cdef bytes string

            if sys.version_info.major > 2:
                string = <bytes>value.encode('utf-8')
            else:
                string = <bytes>value

            xl_font_set_str(self.font, XL_FONT_PROPERTY_PATH, <char*>string)

    property name:
        def __get__(self):
            cdef bytes s = xl_font_get_str(self.font, XL_FONT_PROPERTY_NAME)
            return s.decode() if sys.version_info.major > 2 else s

        def __set__(self, str value):
            cdef bytes string

            if sys.version_info.major > 2:
                string = <bytes>value.encode('utf-8')
            else:
                string = <bytes>value

            xl_font_set_str(self.font, XL_FONT_PROPERTY_NAME, <char*>string)

    property red:
        def __get__(self):
            return xl_font_get_flt(self.font, XL_FONT_PROPERTY_RED)

        def __set__(self, float value):
            xl_font_set_flt(self.font, XL_FONT_PROPERTY_RED, value)

    property green:
        def __get__(self):
            return xl_font_get_flt(self.font, XL_FONT_PROPERTY_GREEN)

        def __set__(self, float value):
            xl_font_set_flt(self.font, XL_FONT_PROPERTY_GREEN, value)

    property blue:
        def __get__(self):
            return xl_font_get_flt(self.font, XL_FONT_PROPERTY_BLUE)

        def __set__(self, float value):
            xl_font_set_flt(self.font, XL_FONT_PROPERTY_BLUE, value)

    property alpha:
        def __get__(self):
            return xl_font_get_flt(self.font, XL_FONT_PROPERTY_ALPHA)

        def __set__(self, float value):
            xl_font_set_flt(self.font, XL_FONT_PROPERTY_ALPHA, value)

    property rgb:
        def __get__(self):
            cdef void* c = xl_font_get_ptr(self.font, XL_FONT_PROPERTY_RGB)
            cdef Vec3 p = Vec3()

            if c != NULL: vec3copy(p.v, <const float*>c)
            return p

        def __set__(self, Vec3 value):
            xl_font_set_ptr(self.font, XL_FONT_PROPERTY_RGB, value.v)

    property rgba:
        def __get__(self):
            cdef void* c = xl_font_get_ptr(self.font, XL_FONT_PROPERTY_RGBA)
            cdef Vec4 p = Vec4()

            if c != NULL: vec4copy(p.v, <const float*>c)
            return p

        def __set__(self, Vec4 value):
            xl_font_set_ptr(self.font, XL_FONT_PROPERTY_RGBA, value.v)

    property open:
        def __get__(self):
            return xl_font_get_int(self.font, XL_FONT_PROPERTY_OPEN)

        def __set__(self, bint value):
            xl_font_set_int(self.font, XL_FONT_PROPERTY_OPEN, value)

    def address(self):
        return <size_t>self.font

    def cast(self):
        return self

    def close(self):
        xl_font_close(self.font); return self

    def load_from_memory(self, Window window, size_t ptr,
                size_t length, int point_size, **kwargs):
        """
        Load a TrueType font from a pointer (cast to an integer) and a buffer size.
        """
        if not self.open:
            # TODO: use xl_font_load_from_memory_ex for exception data
            self.font = xl_font_load_from_memory(window.window,
                                <void*>ptr, length, point_size)

            # convenient way to set font attributes inline on loading
            for key, val in kwargs.items(): setattr(self, key, val)

        return self

    def load_from_array(self, Window window, Array font, int point_size, **kwargs):
        """
        Load a TrueType font from an aegame Array object (see mem.Array.append_file).
        """
        return self.load_from_memory( window, font.address(),
                            len(font), point_size, **kwargs)

    def load_from_bytes(self, Window window, bytes font, int point_size, **kwargs):
        """
        Load a TrueType font from a Python bytes object (return type of file.read).
        """
        return self.load_from_memory( window, <size_t>(<char *>font),
                                    len(font), point_size, **kwargs)

    def load(self, Window window, str filename, int point_size, **kwargs):
        """
        Load a TrueType font from a file. Font path and name are automatically set.
        """
        cdef bytes b_filename

        if not self.open:
            # convert the filename from a unicode string in python 3 to ascii bytes
            if sys.version_info.major > 2:
                b_filename = <bytes>filename.encode('utf-8')
            else:
                b_filename = <bytes>filename

            # TODO: when xl_font_load_ex exists, call it instead for exception data
            self.font = xl_font_load(window.window, <char*>b_filename, point_size)

            # for convenience, set named properties on load
            for k, v in kwargs.items(): setattr(self, k, v)

        return self

    def load_system_monospace(self, Window window, int point_size, **kwargs):
        """
        Load a monospace font from the operating system. Useful for debugging tools.
        """
        if not self.open:
            # TODO: when xl_font_load_system_monospace_ex exists, throw on errors
            self.font = xl_font_load_system_monospace(window.window, point_size)

            # for convenience, set named properties on load
            for k, v in kwargs.items(): setattr(self, k, v)

        return self

    def text_size(self, str string):
        """
        Get the size of a string, as it would be rendered to an image or texture.
        """
        cdef bytes b_string

        cdef int w = 0
        cdef int h = 0

        if sys.version_info.major > 2:
            b_string = <bytes>string.encode('utf-8') # utf -> bytes
        else:
            b_string = <bytes>string # use oldschool py2k ascii str

        xl_font_text_size(self.font, &w, &h, "%s", <char*>b_string)
        return (w, h)

    def render_image(self, str string, object cls=Image):
        """
        Create a new Image object with `string` rendered into it. The type
        of the returned image can also be specified for custom subclassing.
        """
        cdef Image image = cls()
        cdef bytes b_str

        if sys.version_info.major > 2:
            b_str = <bytes>string.encode('utf-8') # convert utf-8 to bytes
        else:
            b_str = <bytes>string # keep oldschool py2k ascii bytes string

        xl_font_render_image(self.font, &image.image, "%s", <char *>b_str)
        return image

    def render_texture(self, str string, object cls=Texture):
        """
        Create a new texture object with `string` rendered into it. The type
        of the returned texture can also be specified for custom subclassing.
        """
        cdef bytes s

        if sys.version_info.major > 2:
            s = <bytes>string.encode('utf-8') # convert unicode str to bytes
        else:
            s = <bytes>string # use the oldschool python 2 ascii byte string

        return cls(<size_t>xl_font_render_texture(self.font, "%s", <char*>s))

    def blit( self, str string, Image dst, int x, int y,
                        bint r = True, bint g = True,
                        bint b = True, bint a = True):
        """
        Blit a string into an image at (x, y), using standard alpha blending.
        This is essentially the software rendering equivalent of Font.draw().
        """
        cdef bytes s

        if sys.version_info.major > 2:
            s = <bytes>string.encode('utf-8') # convert unicode str to bytes
        else:
            s = <bytes>string # use the oldschool python 2 ascii byte string

        xl_font_blit(self.font, &dst.image, x, y, r, g, b, a, "%s", <char*>s)
        return self

    def draw(self, str string, Vec2 pos):
        """
        Render a string into the current window render target at (x, y). For
        custom scaling, clipping, and/or rotation, render strings to textures
        and call Texture.draw_ex(). Don't forget to close them afterwards!!!
        """
        cdef bytes b_string

        # convert unicode strings to bytes, or keep oldschool ascii strings
        if sys.version_info.major > 2:
            b_string = <bytes>string.encode('utf-8')
        else:
            b_string = <bytes>string

        xl_font_draw(self.font, pos.v, "%s", <char *>b_string); return self

# ==============================================================================
# ~ [ streaming music ]
# ==============================================================================

cdef class Music:
    """
    Handles a single global streaming (read in chunks) compressed audio file.
    Do not create an instance of this; it's an interface to a global system.
    """
    def __repr__(self):
        return "{}({})".format(self.__class__.__name__, self.status)

    def __nonzero__(self):
        return xl_music_get_int(XL_MUSIC_PROPERTY_PLAYING)

    def __reduce__(self):
        raise TypeError('cannot pickle {}'.format(self))

    def __copy__(self):
        raise TypeError('cannot copy {}'.format(self))

    def __call__(self, *a, **k):
        return self.play(*a, **k)

    property playing:
        def __get__(self):
            return xl_music_get_int(XL_MUSIC_PROPERTY_PLAYING)

        def __set__(self, bint value):
            xl_music_set_int(XL_MUSIC_PROPERTY_PLAYING, value)

    property paused:
        def __get__(self):
            return xl_music_get_int(XL_MUSIC_PROPERTY_PAUSED)

        def __set__(self, bint value):
            xl_music_set_int(XL_MUSIC_PROPERTY_PAUSED, value)

    property fading_in:
        def __get__(self):
            return xl_music_get_int(XL_MUSIC_PROPERTY_FADING_IN)

    property fading_out:
        def __get__(self):
            return xl_music_get_int(XL_MUSIC_PROPERTY_FADING_OUT)

    property status:
        def __get__(self):
            cdef bytes s = xl_music_get_str(XL_MUSIC_PROPERTY_STATUS)
            return s.decode() if sys.version_info.major > 2 else s

        def __set__(self, str value):
            cdef bytes string

            if sys.version_info.major > 2:
                string = <bytes>value.encode('utf-8')
            else:
                string = <bytes>value

            xl_music_set_str(XL_MUSIC_PROPERTY_STATUS, <char*>string)

    property duration:
        def __get__(self):
            return xl_music_get_dbl(XL_MUSIC_PROPERTY_DURATION)

    property position:
        def __get__(self):
            return xl_music_get_dbl(XL_MUSIC_PROPERTY_POSITION)

        def __set__(self, double value):
            xl_music_set_dbl(XL_MUSIC_PROPERTY_POSITION, value)

    property volume:
        def __get__(self):
            return xl_music_get_dbl(XL_MUSIC_PROPERTY_VOLUME)

        def __set__(self, double value):
            xl_music_set_dbl(XL_MUSIC_PROPERTY_VOLUME, value)

    property path:
        def __get__(self):
            cdef bytes s = xl_music_get_str(XL_MUSIC_PROPERTY_PATH)
            return s.decode() if sys.version_info.major > 2 else s

        def __set__(self, str value):
            cdef bytes string

            if sys.version_info.major > 2:
                string = <bytes>value.encode('utf-8')
            else:
                string = <bytes>value

            xl_music_set_str(XL_MUSIC_PROPERTY_PATH, <char*>string)

    property name:
        def __get__(self):
            cdef bytes s = xl_music_get_str(XL_MUSIC_PROPERTY_NAME)
            return s.decode() if sys.version_info.major > 2 else s

        def __set__(self, str value):
            cdef bytes string

            if sys.version_info.major > 2:
                string = <bytes>value.encode('utf-8')
            else:
                string = <bytes>value

            xl_music_set_str(XL_MUSIC_PROPERTY_NAME, <char*>string)

    @classmethod
    def fade_in(cls, str filename, bint loop, double fade_in,
                                double start_pos, **kwargs):
        """
        Begin streaming a music file at a given point (in seconds),
        optionally fading in from silence over a number of seconds.
        """
        cdef bytes b_file

        # convert unicode strings to bytes, or use oldschool ascii
        if sys.version_info.major > 2:
            b_file = <bytes>filename.encode('utf-8')
        else:
            b_file = <bytes>filename

        xl_music_fade_in(<char *>b_file, loop, fade_in, start_pos)

        # for k, v in kwargs.items(): setattr(cls, k, v)
        for k, v in kwargs.items(): setattr(music, k, v)

    @staticmethod
    def fade_out(double fade_out): xl_music_fade_out(fade_out)

    @classmethod
    def play(cls, str filename, **kwargs):
        """
        Begin streaming a music file immediately from the beginning.
        """
        # TODO: call xl_music_play in case the difference matters,
        # like if play is implemented but fade_in is somehow not...
        cls.fade_in(filename, False, 0.0, 0.0, **kwargs)

    @staticmethod
    def stop(): xl_music_stop()

music = Music()

# ==============================================================================
# ~ [ sound effects ]
# ==============================================================================

cdef class Sound:
    """
    A static (completely loaded into memory) audio file for immediate playback.
    """
    cdef xl_sound_t* sound

    def __init__(self, size_t reference=0):
        self.sound = <xl_sound_t*>reference

    def __repr__(self):
        return "{}({})".format(self.__class__.__name__, self.status)

    def __hash__(self):
        return hash(self.address())

    def __richcmp__(self, Sound other, int op):
        if   op == 0: return self.address() <  other.address()
        elif op == 1: return self.address() <= other.address()
        elif op == 2: return self.address() == other.address()
        elif op == 3: return self.address() != other.address()
        elif op == 4: return self.address() >  other.address()
        elif op == 5: return self.address() >= other.address()

        else: assert 0

    def __nonzero__(self):
        return xl_sound_get_int(self.sound, XL_SOUND_PROPERTY_OPEN)

    def __reduce__(self):
        raise TypeError('cannot pickle {}'.format(self))

    def __copy__(self):
        raise TypeError('cannot copy {}'.format(self))

    def __call__(self, *a, **k):
        return self.play(*a, **k)

    @staticmethod
    def print_all(): return xl_sound_print_all()

    @staticmethod
    def count_all(): return xl_sound_count_all()

    @classmethod
    def list_all(cls):
        """
        Gather references to all open, active, valid sounds in a single list.
        """
        cdef xl_sound_t* sounds[4096]
        cdef int i
        cdef list objects = []

        if xl_sound_count_all() > 4096:
            raise MemoryError("too many open sounds for temp")

        xl_sound_list_all(sounds)

        for i in range(<int>xl_sound_count_all()):
            objects.append(cls(reference = <size_t>sounds[i]))

        return objects

    @staticmethod
    def close_all(): xl_sound_close_all()

    property id:
        def __get__(self):
            return xl_sound_get_int(self.sound, XL_SOUND_PROPERTY_ID)

    property duration:
        def __get__(self):
            return xl_sound_get_dbl(self.sound, XL_SOUND_PROPERTY_DURATION)

    property volume:
        def __get__(self):
            return xl_sound_get_dbl(self.sound, XL_SOUND_PROPERTY_VOLUME)

        def __set__(self, double value):
            xl_sound_set_dbl(self.sound, XL_SOUND_PROPERTY_VOLUME, value)

    property status:
        def __get__(self):
            cdef bytes s = xl_sound_get_str(self.sound, XL_SOUND_PROPERTY_STATUS)
            return s.decode() if sys.version_info.major > 2 else s

        def __set__(self, str value):
            cdef bytes string

            if sys.version_info.major > 2:
                string = <bytes>value.encode('utf-8')
            else:
                string = <bytes>value

            xl_sound_set_str(self.sound, XL_SOUND_PROPERTY_STATUS, <char*>string)

    property path:
        def __get__(self):
            cdef bytes s = xl_sound_get_str(self.sound, XL_SOUND_PROPERTY_PATH)
            return s.decode() if sys.version_info.major > 2 else s

        def __set__(self, str value):
            cdef bytes string

            if sys.version_info.major > 2:
                string = <bytes>value.encode('utf-8')
            else:
                string = <bytes>value

            xl_sound_set_str(self.sound, XL_SOUND_PROPERTY_PATH, <char*>string)

    property name:
        def __get__(self):
            cdef bytes s = xl_sound_get_str(self.sound, XL_SOUND_PROPERTY_NAME)
            return s.decode() if sys.version_info.major > 2 else s

        def __set__(self, str value):
            cdef bytes string

            if sys.version_info.major > 2:
                string = <bytes>value.encode('utf-8')
            else:
                string = <bytes>value

            xl_sound_set_str(self.sound, XL_SOUND_PROPERTY_NAME, <char*>string)

    property open:
        def __get__(self):
            return xl_sound_get_int(self.sound, XL_SOUND_PROPERTY_OPEN)

        def __set__(self, bint value):
            xl_sound_set_int(self.sound, XL_SOUND_PROPERTY_OPEN, value)

    def address(self):
        return <size_t>self.sound

    def cast(self):
        return self

    def close(self):
        xl_sound_close(self.sound); return self

    def load_from_memory(self, size_t ptr, size_t length, **kwargs):
        """
        Load a sound effect from a pointer (cast to int) and a buffer size.
        """
        if not self.open:
            self.sound = xl_sound_load_from_memory(<void*>ptr, length)

            # for convenience, set named properties on load
            for k, v in kwargs.items(): setattr(self, k, v)

        return self

    def load_from_array(self, Array sound, **kwargs):
        return self.load_from_memory(sound.address(), len(sound), **kwargs)

    def load_from_bytes(self, bytes sound, **kwargs):
        return self.load_from_memory(<size_t>(<char *>sound),
                                        len(sound), **kwargs)

    def load(self, str filename, **kwargs):
        """
        Load a sound effect from a file. Path and name are automatically set.
        """
        cdef bytes b_filename

        if not self.open:
            # convert unicode filename to ascii, or keep oldschool bytes str
            if sys.version_info.major > 2:
                b_filename = <bytes>filename.encode('utf-8')
            else:
                b_filename = <bytes>filename

            # TODO: call xl_sound_load_ex once it exists, for exception data
            self.sound = xl_sound_load(< char* >b_filename)

            # for convenience, set named properties on load
            for k, v in kwargs.items(): setattr(self, k, v)

        return self

    def play(self, int count = 1, double fade_in = 0, double length = -1):
        """
        Play the sound N times, with an optional fade in effect and cutoff.
        """
        xl_sound_fade_in(self.sound, count, fade_in, length); return self

    fade_in = play

    def fade_out(self, double fade_out):
        """
        Fade out all playing instances of this sound effect across N seconds.
        """
        xl_sound_fade_out(self.sound, fade_out); return self

    @staticmethod
    def fade_all_out(double fade_out): xl_sound_fade_out(NULL, fade_out)

    def stop(self):
        """
        Immediately stop all playing instances of this static sound effect.
        """
        xl_sound_stop(self.sound); return self

    @staticmethod
    def stop_all(): xl_sound_stop(NULL)

# ==============================================================================
# ~ [ keyboard input ]
# ==============================================================================

cdef class Keyboard:
    """
    Interface to a standard keyboard for press/release and text editing events.
    """
    cdef xl_keyboard_t* keyboard

    def __init__(self, size_t reference=0):
        """
        Create a keyboard object with a pre-existing pointer. As keyboards are
        input devices, they cannot be manually created (only in plugin events).
        """
        self.keyboard = <xl_keyboard_t*>reference

    def __repr__(self):
        return "{}({})".format(self.__class__.__name__, self.status)

    def __hash__(self):
        return hash(self.address())

    def __richcmp__(self, Keyboard other, int op):
        if   op == 0: return self.address() <  other.address()
        elif op == 1: return self.address() <= other.address()
        elif op == 2: return self.address() == other.address()
        elif op == 3: return self.address() != other.address()
        elif op == 4: return self.address() >  other.address()
        elif op == 5: return self.address() >= other.address()

        else: assert 0

    def __nonzero__(self):
        return xl_keyboard_get_int(self.keyboard, XL_KEYBOARD_PROPERTY_OPEN)

    def __reduce__(self):
        raise TypeError('cannot pickle {}'.format(self))

    def __copy__(self):
        raise TypeError('cannot copy {}'.format(self))

    def __call__(self, str key):
        """
        Check if a given key is currently being pressed on this keyboard.
        """
        cdef bytes k_str

        # TODO: for performance reasons, use the C api for this convenience

        if key == 'shift': return self('left_shift') or self('right_shift')
        if key == 'control': return self('left_control') or self('right_control')
        if key == 'alt': return self('left_alt') or self('right_alt')
        if key == 'gui': return self('left_gui') or self('right_gui')

        # convert the potentially unicode key string to bytes if necessary
        if sys.version_info.major > 2:
            k_str = <bytes>key.encode('utf-8')
        else:
            k_str = <bytes>key

        return bool(xl_keyboard_key_is_down(self.keyboard, # magic casting
                    xl_keyboard_key_index_from_short_name(<char *>k_str)))

    @staticmethod
    def print_all(): return xl_keyboard_print_all()

    @staticmethod
    def count_all(): return xl_keyboard_count_all()

    @classmethod
    def list_all(cls):
        """
        Gather references to all open, active, valid keyboards in a single list.
        """
        cdef xl_keyboard_t* keyboards[4096]
        cdef int i
        cdef list objects = []

        if xl_keyboard_count_all() > 4096:
            raise MemoryError("too many open keyboards for temp")

        xl_keyboard_list_all(keyboards)

        for i in range(<int>xl_keyboard_count_all()):
            objects.append(cls(reference = <size_t>keyboards[i]))

        return objects

    @classmethod
    def get_primary(cls):
        """
        Get the main application keyboard (usually the first one).
        """
        return cls(reference = <size_t>xl_primary_keyboard())

    property id:
        def __get__(self):
            return xl_keyboard_get_int(self.keyboard, XL_KEYBOARD_PROPERTY_ID)

    property down_mods:
        def __get__(self):
            return self._mod_list(xl_keyboard_get_int(self.keyboard, XL_KEYBOARD_PROPERTY_DOWN_MODS))

    property up_mods:
        def __get__(self):
            return self._mod_list(xl_keyboard_get_int(self.keyboard, XL_KEYBOARD_PROPERTY_UP_MODS))

    property down_keys:
        def __get__(self):
            return self._key_list(<size_t>xl_keyboard_get_ptr(self.keyboard, XL_KEYBOARD_PROPERTY_DOWN_KEYS))

    property up_keys:
        def __get__(self):
            return self._key_list(<size_t>xl_keyboard_get_ptr(self.keyboard, XL_KEYBOARD_PROPERTY_UP_KEYS))

    property last_pressed_key:
        def __get__(self):
            cdef bytes s = xl_keyboard_get_str(self.keyboard, XL_KEYBOARD_PROPERTY_LAST_PRESSED_KEY)
            return s.decode() if sys.version_info.major > 2 else s

    property last_released_key:
        def __get__(self):
            cdef bytes s = xl_keyboard_get_str(self.keyboard, XL_KEYBOARD_PROPERTY_LAST_RELEASED_KEY)
            return s.decode() if sys.version_info.major > 2 else s

    property last_pressed_time:
        def __get__(self):
            return xl_keyboard_get_dbl(self.keyboard, XL_KEYBOARD_PROPERTY_LAST_PRESSED_TIME)

    property last_released_time:
        def __get__(self):
            return xl_keyboard_get_dbl(self.keyboard, XL_KEYBOARD_PROPERTY_LAST_RELEASED_TIME)

    property status:
        def __get__(self):
            cdef bytes s = xl_keyboard_get_str(self.keyboard, XL_KEYBOARD_PROPERTY_STATUS)
            return s.decode() if sys.version_info.major > 2 else s # convert str to utf-8

        def __set__(self, str value):
            cdef bytes string

            # in python 3k, convert the unicode status string to ascii, otherwise keep it
            if sys.version_info.major > 2:
                string = <bytes>value.encode('utf-8')
            else:
                string = <bytes>value

            xl_keyboard_set_str(self.keyboard, XL_KEYBOARD_PROPERTY_STATUS, <char*>string)

    property name:
        def __get__(self):
            cdef bytes s = xl_keyboard_get_str(self.keyboard, XL_KEYBOARD_PROPERTY_NAME)
            return s.decode() if sys.version_info.major > 2 else s # convert to unicode

    property primary:
        def __get__(self):
            return xl_keyboard_get_int(self.keyboard, XL_KEYBOARD_PROPERTY_PRIMARY)

    property open:
        def __get__(self):
            return xl_keyboard_get_int(self.keyboard, XL_KEYBOARD_PROPERTY_OPEN)

    def address(self):
        return <size_t>self.keyboard

    def cast(self):
        return self

    @staticmethod
    def _mod_list(xl_keyboard_mod_bit_t mods):
        """
        Convert a modifier bitmask to a list of short mod names.
        """
        cdef int i, b

        cdef list values = []
        cdef bytes mod_string

        for i in range(XL_KEYBOARD_MOD_INDEX_COUNT):
            b = 1 << i

            if (mods & b) != 0:
                mod_string = <bytes>xl_keyboard_mod_short_name[i]

                if sys.version_info.major > 2:
                    values.append(mod_string.decode()) # unicode
                else:
                    values.append(mod_string) # py2k ascii bytes

        if mods & XL_KEYBOARD_MOD_BIT_SHIFT: values.append('shift')
        if mods & XL_KEYBOARD_MOD_BIT_CONTROL: values.append('control')
        if mods & XL_KEYBOARD_MOD_BIT_ALT: values.append('alt')
        if mods & XL_KEYBOARD_MOD_BIT_GUI: values.append('gui')

        return values

    @staticmethod
    def _key_list(size_t keys):
        """
        Convert a keyboard key bitvector to a list of short key names.
        Keys is actually a u8 pointer, to circumvent type limitations.
        """
        cdef u8* key_bitvector = <u8*>keys # cast int to pointer
        cdef int i

        cdef list values = []
        cdef bytes key_string

        # NOTE: short modifier key names are also appended to the end of this list,
        # just like in mod_list. this is simply for user convenience when checking.

        for i in range(XL_KEYBOARD_KEY_INDEX_COUNT):
            if ae_bitvector_get(key_bitvector, i):
                key_string = <bytes>xl_keyboard_key_short_name[i]

                if sys.version_info.major > 2:
                    values.append(key_string.decode()) # unicode
                else:
                    values.append(key_string) # py2k ascii bytes

        if (ae_bitvector_get(key_bitvector, XL_KEYBOARD_KEY_INDEX_LEFT_SHIFT) or
            ae_bitvector_get(key_bitvector, XL_KEYBOARD_KEY_INDEX_RIGHT_SHIFT)):
            values.append('shift')

        if (ae_bitvector_get(key_bitvector, XL_KEYBOARD_KEY_INDEX_LEFT_CONTROL) or
            ae_bitvector_get(key_bitvector, XL_KEYBOARD_KEY_INDEX_RIGHT_CONTROL)):
            values.append('control')

        if (ae_bitvector_get(key_bitvector, XL_KEYBOARD_KEY_INDEX_LEFT_ALT) or
            ae_bitvector_get(key_bitvector, XL_KEYBOARD_KEY_INDEX_RIGHT_ALT)):
            values.append('alt')

        if (ae_bitvector_get(key_bitvector, XL_KEYBOARD_KEY_INDEX_LEFT_GUI) or
            ae_bitvector_get(key_bitvector, XL_KEYBOARD_KEY_INDEX_RIGHT_GUI)):
            values.append('gui')

        return values

    def last_key_pressed_time(self, str key):
        """
        Get the absolute last time a given key was pressed. To get the relative
        time (time since press), use aegame.utl.seconds() - last key press time.
        """
        cdef bytes bkey

        if sys.version_info.major > 2:
            bkey = <bytes>key.encode('utf-8') # convert utf-8 to bytes
        else:
            bkey = <bytes>key # keep the oldschool python 2 key string

        return (xl_keyboard_get_last_key_pressed_time(self.keyboard,
                xl_keyboard_key_index_from_short_name(<char*>bkey)))

    def last_key_released_time(self, str key):
        """
        Get the last absolute time the user let go of a given keyboard key.
        """
        cdef bytes bkey

        if sys.version_info.major > 2:
            bkey = <bytes>key.encode('utf-8') # convert utf-8 to bytes
        else:
            bkey = <bytes>key # keep the oldschool python 2 key string

        return (xl_keyboard_get_last_key_released_time(self.keyboard,
                xl_keyboard_key_index_from_short_name(<char*>bkey)))

    def clear_history(self):
        """
        Reset input tracking so a cheat code doesn't register an effect many times.
        """
        xl_keyboard_clear_history(self.keyboard); return self

    cdef void _key_bitvector(self, u8* out, object key):
        """
        Internal method to convert a key list (or a single key) to a bitvector.
        """
        cdef int i

        # key names have to be converted to ascii before they can be used here
        cdef bytes s

        for i in range(sizeof(xl_keyboard_key_bit_t)):
            out[i] = 0

        if isinstance(key, list):
            for kn in key:
                if sys.version_info.major > 2:
                    s = <bytes>kn.encode('utf-8') # convert utf-8 to ascii string
                else:
                    s = <bytes>kn # keep an oldschool python 2 ascii bytes string

                ae_bitvector_set(out, xl_keyboard_key_index_from_short_name(<char*>s), 1)
        else:
            if sys.version_info.major > 2:
                s = <bytes>key.encode('utf-8') # convert utf-8 to ascii string
            else:
                s = <bytes>key # keep an oldschool python 2 ascii bytes string

            ae_bitvector_set(out, xl_keyboard_key_index_from_short_name(<char*>s), 1)

    def check_history(self, list keys):
        """
        Returns True if the last N keyboard inputs match a list. This can be used
        for cheat code and fighting game combo systems. List items can either be
        key names as strings, or another list of key strings for (A + B, C) combos.
        """
        cdef xl_keyboard_key_bit_t key_vecs[1024]
        cdef int i

        if len(keys) > 1024: raise MemoryError("too many keyboard keys for temp!")
        for i, key in enumerate(keys): self._key_bitvector(key_vecs[i], key)

        return bool(xl_keyboard_check_history(self.keyboard, key_vecs, len(keys)))

# ==============================================================================
# ~ [ mouse input ]
# ==============================================================================

cdef class Mouse:
    """
    Interface to a mouse device for buttons, scroll events, and cursor motion.
    """
    cdef xl_mouse_t* mouse

    def __init__(self, size_t reference=0):
        self.mouse = <xl_mouse_t*>reference

    def __repr__(self):
        return "{}({})".format(self.__class__.__name__, self.status)

    def __hash__(self):
        return hash(self.address())

    def __richcmp__(self, Mouse other, int op):
        if   op == 0: return self.address() <  other.address()
        elif op == 1: return self.address() <= other.address()
        elif op == 2: return self.address() == other.address()
        elif op == 3: return self.address() != other.address()
        elif op == 4: return self.address() >  other.address()
        elif op == 5: return self.address() >= other.address()

        else: assert 0

    def __nonzero__(self):
        return xl_mouse_get_int(self.mouse, XL_MOUSE_PROPERTY_OPEN)

    def __reduce__(self):
        raise TypeError('cannot pickle {}'.format(self))

    def __copy__(self):
        raise TypeError('cannot copy {}'.format(self))

    def __call__(self, str button):
        """
        Given the string of a mouse button, returns whether it is pressed.
        """
        cdef bytes b_str

        # convert unicode button str to ascii, or keep the oldschool bytes
        if sys.version_info.major > 2:
            b_str = <bytes>button.encode('utf-8')
        else:
            b_str = <bytes>button

        return bool(xl_mouse_button_is_down(self.mouse, # magic bytes cast
                    xl_mouse_button_index_from_short_name(<char *>b_str)))

    @staticmethod
    def print_all(): return xl_mouse_print_all()

    @staticmethod
    def count_all(): return xl_mouse_count_all()

    @classmethod
    def list_all(cls):
        """
        Gather references to all open mice in a single list.
        """
        cdef xl_mouse_t* mice[256]
        cdef int i
        cdef list objects = []

        if xl_mouse_count_all() > 256:
            raise MemoryError("too many open mice for temp")

        xl_mouse_list_all(mice)

        for i in range(<int>xl_mouse_count_all()):
            objects.append(cls(reference = <size_t>mice[i]))

        return objects

    @classmethod
    def get_primary(cls):
        """
        Get the main application mouse (usually the first).
        """
        return cls(reference = <size_t>xl_primary_mouse())

    property id:
        def __get__(self):
            return xl_mouse_get_int(self.mouse, XL_MOUSE_PROPERTY_ID)

    property down_buttons:
        def __get__(self):
            return self._button_list(xl_mouse_get_int(self.mouse, XL_MOUSE_PROPERTY_DOWN_BUTTONS))

    property up_buttons:
        def __get__(self):
            return self._button_list(xl_mouse_get_int(self.mouse, XL_MOUSE_PROPERTY_UP_BUTTONS))

    property tribool:
        def __get__(self):
            return xl_mouse_get_int(self.mouse, XL_MOUSE_PROPERTY_TRIBOOL)

    property last_pressed_button:
        def __get__(self):
            cdef bytes s = xl_mouse_get_str(self.mouse, XL_MOUSE_PROPERTY_LAST_PRESSED_BUTTON)
            return s.decode() if sys.version_info.major > 2 else s

    property last_released_button:
        def __get__(self):
            cdef bytes s = xl_mouse_get_str(self.mouse, XL_MOUSE_PROPERTY_LAST_RELEASED_BUTTON)
            return s.decode() if sys.version_info.major > 2 else s

    property last_pressed_time:
        def __get__(self):
            return xl_mouse_get_dbl(self.mouse, XL_MOUSE_PROPERTY_LAST_PRESSED_TIME)

    property last_released_time:
        def __get__(self):
            return xl_mouse_get_dbl(self.mouse, XL_MOUSE_PROPERTY_LAST_RELEASED_TIME)

    property window:
        def __get__(self):
            return Window(reference=<size_t>xl_mouse_get_ptr(self.mouse, XL_MOUSE_PROPERTY_WINDOW))

    property x:
        def __get__(self):
            return xl_mouse_get_dbl(self.mouse, XL_MOUSE_PROPERTY_X)

    property y:
        def __get__(self):
            return xl_mouse_get_dbl(self.mouse, XL_MOUSE_PROPERTY_Y)

    property dx:
        def __get__(self):
            return xl_mouse_get_dbl(self.mouse, XL_MOUSE_PROPERTY_DX)

    property dy:
        def __get__(self):
            return xl_mouse_get_dbl(self.mouse, XL_MOUSE_PROPERTY_DY)

    property relative:
        """
        When the mouse is in relative mode, the cursor is hidden, and the driver
        will try to report continuous motion in the current window. Only relative
        motion events will be delivered, and the mouse position will not change.
        """
        def __get__(self):
            return xl_mouse_get_int(self.mouse, XL_MOUSE_PROPERTY_RELATIVE)

        def __set__(self, bint value):
            xl_mouse_set_int(self.mouse, XL_MOUSE_PROPERTY_RELATIVE, value)

    property visible:
        def __get__(self):
            return xl_mouse_get_int(self.mouse, XL_MOUSE_PROPERTY_VISIBLE)

        def __set__(self, bint value):
            xl_mouse_set_int(self.mouse, XL_MOUSE_PROPERTY_VISIBLE, value)

    property status:
        def __get__(self):
            cdef bytes s = xl_mouse_get_str(self.mouse, XL_MOUSE_PROPERTY_STATUS)
            return s.decode() if sys.version_info.major > 2 else s # get unicode

        def __set__(self, str value):
            cdef bytes string

            # if we need unicode strings for python 3k, convert the ascii status
            if sys.version_info.major > 2:
                string = <bytes>value.encode('utf-8')
            else:
                string = <bytes>value

            xl_mouse_set_str(self.mouse, XL_MOUSE_PROPERTY_STATUS, <char*>string)

    property name:
        def __get__(self):
            cdef bytes s = xl_mouse_get_str(self.mouse, XL_MOUSE_PROPERTY_NAME)
            return s.decode() if sys.version_info.major > 2 else s # to unicode

    property primary:
        def __get__(self):
            return xl_mouse_get_int(self.mouse, XL_MOUSE_PROPERTY_PRIMARY)

    property open:
        def __get__(self):
            return xl_mouse_get_int(self.mouse, XL_MOUSE_PROPERTY_OPEN)

    def address(self):
        return <size_t>self.mouse

    def cast(self):
        return self

    @staticmethod
    def _button_list(xl_mouse_button_bit_t button_mask):
        """
        Internal method to convert a mouse button mask to a list of strings.
        """
        cdef int i, b

        cdef list button_list = []
        cdef bytes button_name

        for i in range(XL_MOUSE_BUTTON_INDEX_COUNT):
            b = 1 << i

            if (button_mask & b) != 0:
                button_name = <bytes>xl_mouse_button_short_name[i]

                if sys.version_info.major > 2:
                    button_list.append(button_name.decode()) # py3k unicode
                else:
                    button_list.append(button_name) # oldschool byte string

        return button_list

    def last_button_pressed_time(self, str button):
        """
        Get the absolute last time a given button was pressed. To get the relative
        time (time since press), use aegame.utl.seconds() - last button press time.
        """
        cdef bytes b

        if sys.version_info.major > 2:
            b = <bytes>button.encode('utf-8') # convert utf-8 str to bytes
        else:
            b = <bytes>button # keep the oldschool python 2 button strings

        return (xl_mouse_get_last_button_pressed_time(self.mouse,
                xl_mouse_button_index_from_short_name(<char*>b)))

    def last_button_released_time(self, str button):
        """
        Get the last absolute time the user let go of a given mouse button.
        """
        cdef bytes b

        if sys.version_info.major > 2:
            b = <bytes>button.encode('utf-8') # convert utf-8 str to bytes
        else:
            b = <bytes>button # keep the oldschool python 2 button strings

        return (xl_mouse_get_last_button_released_time(self.mouse,
                xl_mouse_button_index_from_short_name(<char *>b)))

    def clear_history(self):
        """
        Reset input tracking so a cheat code doesn't register an effect many times.
        """
        xl_mouse_clear_history(self.mouse); return self

    cdef int _button_mask(self, object button):
        """
        Internal method to convert a button list (or a single button) to a bitmask.
        """
        cdef int mask = 0

        # button names have to be converted to ascii before they can be used
        cdef bytes s

        if isinstance(button, list):
            for bn in button:
                if sys.version_info.major > 2:
                    s = <bytes>bn.encode('utf-8') # convert utf-8 to ascii str
                else:
                    s = <bytes>bn # keep oldschool python 2 ascii bytes string

                mask |= <int>xl_mouse_button_bit_from_short_name(<char*>s)
        else:
            if sys.version_info.major > 2:
                s = <bytes>button.encode('utf-8') # convert utf-8 to ascii str
            else:
                s = <bytes>button # keep oldschool python 2 ascii bytes string

            mask |= <int>xl_mouse_button_bit_from_short_name(<char*>s)

        return mask

    def check_history(self, list buttons):
        """
        Returns True if the last N mouse button hits match a list. This can be used
        for cheat code and fighting game combo systems. List items can either be
        button names as strings, or another list of buttons for (A + B, C) combos.
        """
        cdef int m[1024]
        cdef int i

        if len(buttons) > 1024: raise MemoryError("too many buttons for temp!")
        for i, button in enumerate(buttons): m[i] = self._button_mask(button)

        return bool(xl_mouse_check_history(self.mouse, m, len(buttons)))

# ==============================================================================
# ~ [ controller input ]
# ==============================================================================

cdef class Controller:
    """
    Joystick and gamepad interface. May also support other exotic hardware like
    flight sticks, racing wheels, drumkits, and/or Guitar Hero controllers.
    Game controllers can't be created or destroyed programatically, only plugged
    in and unplugged by the user (use the event system to monitor controllers).
    """
    cdef xl_controller_t* controller

    def __init__(self, size_t reference):
        """
        Given a pointer cast to an integer, create a handle to a game controller.
        Any invalid pointer (such as zero) will safely create a `closed` object.
        """
        self.controller = <xl_controller_t*>reference

    def __repr__(self):
        return "{}({})".format(self.__class__.__name__, self.status)

    def __hash__(self):
        return hash(self.address())

    def __richcmp__(self, Controller other, int op):
        if   op == 0: return self.address() <  other.address()
        elif op == 1: return self.address() <= other.address()
        elif op == 2: return self.address() == other.address()
        elif op == 3: return self.address() != other.address()
        elif op == 4: return self.address() >  other.address()
        elif op == 5: return self.address() >= other.address()

        else: assert 0

    def __nonzero__(self):
        return xl_controller_get_int(self.controller, XL_CONTROLLER_PROPERTY_OPEN)

    def __reduce__(self):
        raise TypeError('cannot pickle {}'.format(self))

    def __copy__(self):
        raise TypeError('cannot copy {}'.format(self))

    def __call__(self, str button):
        """
        Given the string of a controller button, returns whether it is pressed.
        """
        cdef bytes b_str

        # convert unicode button string to ascii, or keep the oldschool string
        if sys.version_info.major > 2:
            b_str = <bytes>button.encode('utf-8')
        else:
            b_str = <bytes>button

        return bool(xl_controller_button_is_down(self.controller, # magic cast
                    xl_controller_button_index_from_short_name(<char*>b_str)))

    @staticmethod
    def print_all(): return xl_controller_print_all()

    @staticmethod
    def count_all(): return xl_controller_count_all()

    @classmethod
    def list_all(cls):
        """
        Gather references to all open controllers in a single list.
        """
        cdef xl_controller_t* controllers[256]
        cdef int i
        cdef list objects = []

        if xl_controller_count_all() > 256:
            raise MemoryError("too many open controllers for temp")

        xl_controller_list_all(controllers)

        for i in range(<int>xl_controller_count_all()):
            objects.append(cls(reference = <size_t>controllers[i]))

        return objects

    @classmethod
    def get_primary(cls):
        """
        Get the main application controller (usually the first one).
        """
        return cls(reference = <size_t>xl_primary_controller())

    property id:
        """
        Get the unique integer identifier for this controller. For the actual
        pointer to the controller object, use the `address()` method instead.
        """
        def __get__(self):
            return xl_controller_get_int(self.controller, XL_CONTROLLER_PROPERTY_ID)

    def _get_button_list(self, xl_controller_property_t prop):
        """
        Internal method to convert a button mask to a list of button strings.
        """
        cdef int button_mask = xl_controller_get_int(self.controller, prop)
        cdef int i, b

        cdef list button_list = []
        cdef bytes button_name

        for i in range(XL_CONTROLLER_BUTTON_INDEX_COUNT):
            b = 1 << i

            if (button_mask & b) != 0:
                button_name = <bytes>xl_controller_button_short_name[i]

                # convert the ascii byte string to utf-8, or leave it as-is.
                if sys.version_info.major > 2:
                    button_list.append(button_name.decode()) # py3k unicode
                else:
                    button_list.append(button_name) # oldschool byte string

        return button_list

    property down_buttons:
        def __get__(self):
            return self._get_button_list(XL_CONTROLLER_PROPERTY_DOWN_BUTTONS)

    property up_buttons:
        def __get__(self):
            return self._get_button_list(XL_CONTROLLER_PROPERTY_UP_BUTTONS)

    property shoulder_tribool:
        def __get__(self):
            return xl_controller_get_int(self.controller, XL_CONTROLLER_PROPERTY_SHOULDER_TRIBOOL)

    property dpad_horizontal_tribool:
        def __get__(self):
            return xl_controller_get_int(self.controller, XL_CONTROLLER_PROPERTY_DPAD_HORIZONTAL_TRIBOOL)

    property dpad_vertical_tribool:
        def __get__(self):
            return xl_controller_get_int(self.controller, XL_CONTROLLER_PROPERTY_DPAD_VERTICAL_TRIBOOL)

    property stick_tribool:
        def __get__(self):
            return xl_controller_get_int(self.controller, XL_CONTROLLER_PROPERTY_STICK_TRIBOOL)

    property last_pressed_button:
        """
        Get the string identifier of the last button pressed down on the controller.
        """
        def __get__(self):
            cdef bytes btn_s = <bytes>xl_controller_get_str(self.controller,
                                XL_CONTROLLER_PROPERTY_LAST_PRESSED_BUTTON)

            return btn_s.decode() if sys.version_info.major > 2 else btn_s

    property last_released_button:
        """
        Get the string identifier of the last button released up from the controller.
        """
        def __get__(self):
            cdef bytes btn_s = <bytes>xl_controller_get_str(self.controller,
                                XL_CONTROLLER_PROPERTY_LAST_RELEASED_BUTTON)

            return btn_s.decode() if sys.version_info.major > 2 else btn_s

    property last_pressed_time:
        def __get__(self):
            return xl_controller_get_dbl(self.controller, XL_CONTROLLER_PROPERTY_LAST_PRESSED_TIME)

    property last_released_time:
        def __get__(self):
            return xl_controller_get_dbl(self.controller, XL_CONTROLLER_PROPERTY_LAST_RELEASED_TIME)

    property right_trigger:
        def __get__(self):
            return xl_controller_get_dbl(self.controller, XL_CONTROLLER_PROPERTY_RIGHT_TRIGGER)

    property left_trigger:
        def __get__(self):
            return xl_controller_get_dbl(self.controller, XL_CONTROLLER_PROPERTY_LEFT_TRIGGER)

    property right_deadzone:
        """
        Get/set the right stick deadzone mode and value via a tuple (i.e. ('scaled_radial', 0.2)).
        """
        def __get__(self):
            cdef bytes s = xl_controller_get_str(self.controller, XL_CONTROLLER_PROPERTY_RIGHT_DEADZONE_MODE)

            return (s.decode() if sys.version_info.major > 2 else s, # convert ascii string to unicode?
                    xl_controller_get_dbl(self.controller, XL_CONTROLLER_PROPERTY_RIGHT_DEADZONE_VALUE))

        def __set__(self, tuple value):
            cdef bytes mode = value[0].encode('utf-8') if sys.version_info.major > 2 else value[0]

            xl_controller_set_str(self.controller, XL_CONTROLLER_PROPERTY_RIGHT_DEADZONE_MODE, <char*>mode)
            xl_controller_set_dbl(self.controller, XL_CONTROLLER_PROPERTY_RIGHT_DEADZONE_VALUE, value[1])

    property left_deadzone:
        """
        Get/set the left stick deadzone mode and value via a tuple (i.e. ('scaled_radial', 0.2)).
        """
        def __get__(self):
            cdef bytes s = xl_controller_get_str(self.controller, XL_CONTROLLER_PROPERTY_LEFT_DEADZONE_MODE)

            return (s.decode() if sys.version_info.major > 2 else s, # convert ascii string to unicode?
                    xl_controller_get_dbl(self.controller, XL_CONTROLLER_PROPERTY_LEFT_DEADZONE_VALUE))

        def __set__(self, tuple value):
            cdef bytes mode = value[0].encode('utf-8') if sys.version_info.major > 2 else value[0]

            xl_controller_set_str(self.controller, XL_CONTROLLER_PROPERTY_LEFT_DEADZONE_MODE, <char*>mode)
            xl_controller_set_dbl(self.controller, XL_CONTROLLER_PROPERTY_LEFT_DEADZONE_VALUE, value[1])

    property right_stick_angle:
        def __get__(self):
            return xl_controller_get_dbl(self.controller, XL_CONTROLLER_PROPERTY_RIGHT_STICK_ANGLE)

    property right_stick_magnitude:
        def __get__(self):
            return xl_controller_get_dbl(self.controller, XL_CONTROLLER_PROPERTY_RIGHT_STICK_MAGNITUDE)

    property left_stick_angle:
        def __get__(self):
            return xl_controller_get_dbl(self.controller, XL_CONTROLLER_PROPERTY_LEFT_STICK_ANGLE)

    property left_stick_magnitude:
        def __get__(self):
            return xl_controller_get_dbl(self.controller, XL_CONTROLLER_PROPERTY_LEFT_STICK_MAGNITUDE)

    property right_stick:
        def __get__(self): return (
            xl_controller_get_dbl(self.controller, XL_CONTROLLER_PROPERTY_RIGHT_STICK_X),
            xl_controller_get_dbl(self.controller, XL_CONTROLLER_PROPERTY_RIGHT_STICK_Y))

    property left_stick:
        def __get__(self): return (
            xl_controller_get_dbl(self.controller, XL_CONTROLLER_PROPERTY_LEFT_STICK_X),
            xl_controller_get_dbl(self.controller, XL_CONTROLLER_PROPERTY_LEFT_STICK_Y))

    property status:
        """
        Get some interesting info about the controller, for internal use with __repr__().
        Note that for most or all objects, setting the status string doesn't do anything -
        it's just a legacy holdover from when I thought these strings might be parsable.
        """
        def __get__(self):
            cdef bytes s = xl_controller_get_str( self.controller,
                                    XL_CONTROLLER_PROPERTY_STATUS)

            return s.decode() if sys.version_info.major > 2 else s

        def __set__(self, str value):
            cdef bytes string

            if sys.version_info.major > 2:
                string = <bytes>value.encode('utf-8') # convert py3 utf-8 to ascii
            else:
                string = <bytes>value # keep oldschool python 2 ascii bytes string

            xl_controller_set_str( self.controller, XL_CONTROLLER_PROPERTY_STATUS,
                                                                    <char*>string)

    property name:
        """
        Get the string identifier of the controller ("Sony DualShock 4 USB" etc).
        On the PC implementation, this string is taken from the SDL mapping file,
        and on consoles this will likely contain the port `self` is plugged into.
        """
        def __get__(self):
            cdef bytes s = xl_controller_get_str( self.controller,
                                    XL_CONTROLLER_PROPERTY_NAME)

            return s.decode() if sys.version_info.major > 2 else s

    property primary:
        """
        Returns True if the controller is the first one the user plugged in, or
        if it's in the first controller slot on game consoles (user index one).
        """
        def __get__(self): return xl_controller_get_int(self.controller,
                                        XL_CONTROLLER_PROPERTY_PRIMARY)

    property open:
        """
        Returns True if the controller is active (currently plugged in). Unlike
        most objects, the controller cannot be manually closed, only unplugged.
        """
        def __get__(self): return xl_controller_get_int(self.controller,
                                            XL_CONTROLLER_PROPERTY_OPEN)

    def address(self):
        return <size_t>self.controller

    def cast(self):
        return self

    def last_button_pressed_time(self, str button):
        """
        Get the absolute last time a given button was pressed. To get the relative
        time (time since press), use aegame.utl.seconds() - last button press time.
        """
        cdef bytes bt_str

        if sys.version_info.major > 2:
            bt_str = <bytes>button.encode('utf-8') # convert utf-8 to bytes
        else:
            bt_str = <bytes>button # keep oldschool python 2 button strings

        return (xl_controller_get_last_button_pressed_time(self.controller,
                xl_controller_button_index_from_short_name(<char*>bt_str)))

    def last_button_released_time(self, str button):
        """
        Get the last absolute time the user let go of a given controller button.
        """
        cdef bytes bt_str

        if sys.version_info.major > 2:
            bt_str = <bytes>button.encode('utf-8') # convert utf-8 to bytes
        else:
            bt_str = <bytes>button # keep oldschool python 2 button strings

        return (xl_controller_get_last_button_released_time(self.controller,
                xl_controller_button_index_from_short_name(<char*>bt_str)))

    def clear_history(self):
        """
        Reset input tracking so a cheat code doesn't register an effect many times.
        """
        xl_controller_clear_history(self.controller); return self

    cdef int _button_mask(self, object button):
        """
        Internal method to convert a button list (or a single button) to a mask.
        """
        cdef int mask = 0

        # button names have to be converted to ascii before they can be used
        cdef bytes s

        if isinstance(button, list):
            for bn in button:
                if sys.version_info.major > 2:
                    s = <bytes>bn.encode('utf-8') # convert utf-8 to ascii str
                else:
                    s = <bytes>bn # keep oldschool python 2 ascii bytes string

                mask |= <int>xl_controller_button_bit_from_short_name(<char*>s)
        else:
            if sys.version_info.major > 2:
                s = <bytes>button.encode('utf-8') # convert utf-8 to ascii str
            else:
                s = <bytes>button # keep oldschool python 2 ascii bytes string

            mask |= <int>xl_controller_button_bit_from_short_name(<char*>s)

        return mask

    def check_history(self, list buttons):
        """
        Returns True if the last N controller inputs match a list. This can be used
        for cheat code and fighting game combo systems. List items can either be
        button names as strings, or another list of buttons for (A + B, C) combos.
        """
        cdef int m[1024]
        cdef int i

        if len(buttons) > 1024: raise MemoryError("too many buttons for temp!")
        for i, button in enumerate(buttons): m[i] = self._button_mask(button)

        return bool(xl_controller_check_history(self.controller, m, len(buttons)))

    def get_trigger(self, str which):
        """
        Get the shoulder trigger state based on a character identifier ('L', 'R').
        """
        return xl_controller_get_trigger(self.controller, <char>ord(which))

    def get_deadzone(self, str which):
        """
        Get the deadzone mode and margin value for a given game controller stick.
        See xl_core.h for the listing of all supported controller deadzone modes.
        """
        cdef xl_controller_deadzone_mode_t mode

        cdef bytes b_mode
        cdef double value

        xl_controller_get_deadzone(self.controller, <char>ord(which), &mode, &value)
        b_mode = xl_controller_deadzone_short_name[<size_t>mode]

        return (b_mode.decode() if sys.version_info.major > 2 else b_mode, value)

    def set_deadzone(self, str which, str mode, double value):
        """
        Set the deadzone mode and margin, for dealing with old worn out joysticks
        or manipulating game feel for certain genres (FPS motion vs. aiming, etc).
        """
        cdef bytes mstr

        if sys.version_info.major > 2:
            mstr = <bytes>mode.encode('utf-8') # convert unicode string to ascii
        else:
            mstr = <bytes>mode # keep the oldschool python 2k ascii bytes string

        xl_controller_set_deadzone(self.controller, <char>ord(which), # str2char
            xl_controller_deadzone_mode_from_short_name(<char*>mstr), value)

        return self

    def get_stick_angle(self, str which):
        return xl_controller_get_stick_angle(self.controller, <char>ord(which))

    def get_stick_magnitude(self, str which):
        return xl_controller_get_stick_magnitude(self.controller, <char>ord(which))

    def get_stick(self, str which):
        """
        Get the cartesian coordinates (X and Y) of a given game controller stick.
        Methods also exists to get polar coordinates (stick angle and magnitude).
        """
        cdef double x
        cdef double y

        xl_controller_get_stick(self.controller, <char>ord(which), &x, &y)
        return (x, y)

# ==============================================================================
# ~ [ atlas animation ]
# ==============================================================================

cdef class Animation:
    """
    Render a sequence of frames within a single texture atlas, over a set period
    of time. Can be loaded from a variety of sources (textures, archives, dirs).
    """
    cdef xl_animation_t* animation

    def __init__(self, size_t reference=0):
        self.animation = <xl_animation_t*>reference

    def __repr__(self):
        return "{}({})".format(self.__class__.__name__, self.status)

    def __hash__(self):
        return hash(self.address())

    def __richcmp__(self, Animation other, int op):
        if   op == 0: return self.address() <  other.address()
        elif op == 1: return self.address() <= other.address()
        elif op == 2: return self.address() == other.address()
        elif op == 3: return self.address() != other.address()
        elif op == 4: return self.address() >  other.address()
        elif op == 5: return self.address() >= other.address()

        else: assert 0

    def __nonzero__(self):
        return xl_animation_get_int(self.animation, XL_ANIMATION_PROPERTY_OPEN)

    def __reduce__(self):
        raise TypeError('cannot pickle {}'.format(self))

    def __copy__(self):
        return self.__class__(reference=<size_t>xl_animation_copy(self.animation))

    copy = __copy__

    def __call__(self, *a, **k):
        return self.draw(*a, **k)

    @staticmethod
    def print_all(): return xl_animation_print_all()

    @staticmethod
    def count_all(): return xl_animation_count_all()

    @classmethod
    def list_all(cls):
        """
        Gather references to all open, active, valid animations in a single list.
        """
        cdef xl_animation_t* animations[2048]
        cdef int i
        cdef list objects = []

        if xl_animation_count_all() > 2048:
            raise MemoryError("too many open animations for temp")

        xl_animation_list_all(animations)

        for i in range(<int>xl_animation_count_all()):
            objects.append(cls(reference = <size_t>animations[i]))

        return objects

    @staticmethod
    def close_all(): xl_animation_close_all()

    property id:
        def __get__(self):
            return xl_animation_get_int(self.animation, XL_ANIMATION_PROPERTY_ID)

    property atlas:
        def __get__(self):
            return Texture(reference=<size_t>xl_animation_get_tex( # get tex ref
                                    self.animation, XL_ANIMATION_PROPERTY_ATLAS))

        def __set__(self, Texture value):
            xl_animation_set_tex(self.animation, XL_ANIMATION_PROPERTY_ATLAS,
                                value.texture if value is not None else NULL)

    property owns_atlas:
        def __get__(self):
            return xl_animation_get_int(self.animation, XL_ANIMATION_PROPERTY_OWNS_ATLAS)

        def __set__(self, bint value):
            xl_animation_set_int(self.animation, XL_ANIMATION_PROPERTY_OWNS_ATLAS, value)

    property frame_width:
        def __get__(self):
            return xl_animation_get_int(self.animation, XL_ANIMATION_PROPERTY_FRAME_WIDTH)

        def __set__(self, int value):
            xl_animation_set_int(self.animation, XL_ANIMATION_PROPERTY_FRAME_WIDTH, value)

    property frame_height:
        def __get__(self):
            return xl_animation_get_int(self.animation, XL_ANIMATION_PROPERTY_FRAME_HEIGHT)

        def __set__(self, int value):
            xl_animation_set_int(self.animation, XL_ANIMATION_PROPERTY_FRAME_HEIGHT, value)

    property frame_size:
        def __get__(self):
            return (self.frame_width, self.frame_height)

        def __set__(self, object value):
            self.frame_width, self.frame_height = value

    property first_frame:
        def __get__(self):
            return xl_animation_get_int(self.animation, XL_ANIMATION_PROPERTY_FIRST_FRAME)

        def __set__(self, int value):
            xl_animation_set_int(self.animation, XL_ANIMATION_PROPERTY_FIRST_FRAME, value)

    property frame_count:
        def __get__(self):
            return xl_animation_get_int(self.animation, XL_ANIMATION_PROPERTY_FRAME_COUNT)

        def __set__(self, int value):
            xl_animation_set_int(self.animation, XL_ANIMATION_PROPERTY_FRAME_COUNT, value)

    property frame_time:
        def __get__(self):
            return xl_animation_get_dbl(self.animation, XL_ANIMATION_PROPERTY_FRAME_TIME)

        def __set__(self, double value):
            xl_animation_set_dbl(self.animation, XL_ANIMATION_PROPERTY_FRAME_TIME, value)

    property total_time:
        def __get__(self):
            return xl_animation_get_dbl(self.animation, XL_ANIMATION_PROPERTY_TOTAL_TIME)

        def __set__(self, double value):
            xl_animation_set_dbl(self.animation, XL_ANIMATION_PROPERTY_TOTAL_TIME, value)

    property current_frame:
        def __get__(self):
            return xl_animation_get_int(self.animation, XL_ANIMATION_PROPERTY_CURRENT_FRAME)

        def __set__(self, int value):
            xl_animation_set_int(self.animation, XL_ANIMATION_PROPERTY_CURRENT_FRAME, value)

    property position:
        def __get__(self):
            return xl_animation_get_dbl(self.animation, XL_ANIMATION_PROPERTY_POSITION)

        def __set__(self, double value):
            xl_animation_set_dbl(self.animation, XL_ANIMATION_PROPERTY_POSITION, value)

    property loops:
        def __get__(self):
            return xl_animation_get_int(self.animation, XL_ANIMATION_PROPERTY_LOOPS)

        def __set__(self, bint value):
            xl_animation_set_int(self.animation, XL_ANIMATION_PROPERTY_LOOPS, value)

    property finished:
        def __get__(self):
            return xl_animation_get_int(self.animation, XL_ANIMATION_PROPERTY_FINISHED)

        def __set__(self, bint value):
            xl_animation_set_int(self.animation, XL_ANIMATION_PROPERTY_FINISHED, value)

    property status:
        def __get__(self):
            cdef bytes s = xl_animation_get_str(self.animation, XL_ANIMATION_PROPERTY_STATUS)
            return s.decode() if sys.version_info.major > 2 else s

        def __set__(self, str value):
            cdef bytes string

            if sys.version_info.major > 2:
                string = <bytes>value.encode('utf-8')
            else:
                string = <bytes>value

            xl_animation_set_str(self.animation, XL_ANIMATION_PROPERTY_STATUS, <char*>string)

    property path:
        def __get__(self):
            cdef bytes s = xl_animation_get_str(self.animation, XL_ANIMATION_PROPERTY_PATH)
            return s.decode() if sys.version_info.major > 2 else s

        def __set__(self, str value):
            cdef bytes string

            if sys.version_info.major > 2:
                string = <bytes>value.encode('utf-8')
            else:
                string = <bytes>value

            xl_animation_set_str(self.animation, XL_ANIMATION_PROPERTY_PATH, <char*>string)

    property name:
        def __get__(self):
            cdef bytes s = xl_animation_get_str(self.animation, XL_ANIMATION_PROPERTY_NAME)
            return s.decode() if sys.version_info.major > 2 else s

        def __set__(self, str value):
            cdef bytes string

            if sys.version_info.major > 2:
                string = <bytes>value.encode('utf-8')
            else:
                string = <bytes>value

            xl_animation_set_str(self.animation, XL_ANIMATION_PROPERTY_NAME, <char*>string)

    property open:
        def __get__(self):
            return xl_animation_get_int(self.animation, XL_ANIMATION_PROPERTY_OPEN)

        def __set__(self, bint value):
            xl_animation_set_int(self.animation, XL_ANIMATION_PROPERTY_OPEN, value)

    def address(self):
        return <size_t>self.animation

    def cast(self):
        return self

    def close(self):
        xl_animation_close(self.animation); return self

    def create(self, **kwargs):
        """
        Manually create a new animation, and set properties via keyword arguments.
        """
        if not self.open:
            self.animation = xl_animation_create()

            # convenient way to set named animation properties inline
            for key, val in kwargs.items(): setattr(self, key, val)

        return self

    def load(self, Window window, str filename, int frame_width = 0,
                                    int frame_height = 0, **kwargs):
        """
        Load an animation file (supported file types depend upon the implementation).
        """
        cdef ae_image_error_t error_status = AE_IMAGE_NO_CODEC # default stub error

        # convert unicode strings to bytes in py3k, or keep oldschool ascii strings
        cdef bytes file_str, err

        if not self.open:
            if sys.version_info.major > 2:
                file_str = <bytes>filename.encode('utf-8')
            else:
                file_str = <bytes>filename

            self.animation = xl_animation_load_ex(window.window, <char *>file_str,
                                        frame_width, frame_height, &error_status)

            if error_status != AE_IMAGE_SUCCESS:
                err = <bytes>ae_image_error_message(error_status, <char*>file_str)

                if sys.version_info.major > 2:
                    raise IOError(err.decode())
                else:
                    raise IOError(err)

            # convenient way to set named animation properties inline
            for key, val in kwargs.items(): setattr(self, key, val)

        return self

    @staticmethod
    def reset_all():
        xl_animation_reset_all()

    def reset(self):
        xl_animation_reset(self.animation); return self

    @staticmethod
    def update_all(double dt):
        """
        Advance all active animations by a given number of seconds (usually frame delta).
        """
        xl_animation_update_all(dt)

    def update(self, double dt):
        """
        Advance this animation by a given number of seconds (usually frame time delta).
        """
        xl_animation_update(self.animation, dt); return self

    def src_rect(self):
        """
        Map the 1D animation index (current frame) to the 2D region of the atlas to draw.
        """
        cdef FloatRect rect = FloatRect()

        xl_animation_src_rect(self.animation, rect.rect)
        return rect

    def dst_rect(self, Vec2 pos=Vec2(), Vec2 scale=Vec2(1.0, 1.0)):
        """
        Create a destination rect (region of the render target to stretch frame onto).
        """
        cdef FloatRect rect = FloatRect()

        xl_animation_dst_rect(self.animation, rect.rect, pos.v, scale.v)
        return rect

    rect = dst_rect

    def draw_ex(self, FloatRect dst_rect=None, double angle=0.0, Vec2 center=None):
        """
        Draw the current frame with rotation and scaling (no clipping of source rect).
        """
        xl_animation_draw_ex(self.animation,

            NULL if dst_rect is None else dst_rect.rect,
            angle, NULL if center is None else center.v)

        return self

    def draw(self, Vec2 pos=Vec2()):
        """
        Draw the current frame without rotation, scaling, or clipping of the source rect.
        """
        xl_animation_draw(self.animation, pos.v); return self

# ==============================================================================
# ~ [ timer objects ]
# ==============================================================================

cdef class Clock:
    """
    A local set of named timers that fire events when they expire. Useful
    for stuff like entity behavior (my "on_fire" timer is active, so for
    the next five seconds I'll render myself on fire and take damage etc).
    """
    cdef xl_clock_t* clock

    def __init__(self, *args, **kwargs):
        if 'reference' in kwargs:
            self.clock = <xl_clock_t*>(<size_t>kwargs['reference'])

        elif args and args[0] is None:
            self.clock = NULL # HACK: special serialization backdoor

        else:
            self.clock = xl_clock_create()

            # easy syntax to create a named clock - Clock("test")
            if args: self.name = args[0]

            # convenient way to set named animation properties inline
            for key, val in kwargs.items(): setattr(self, key, val)

    def __repr__(self):
        return "{}({})".format(self.__class__.__name__, self.status)

    def __hash__(self):
        return hash(self.address())

    def __richcmp__(self, Clock other, int op):
        if   op == 0: return self.address() <  other.address()
        elif op == 1: return self.address() <= other.address()
        elif op == 2: return self.address() == other.address()
        elif op == 3: return self.address() != other.address()
        elif op == 4: return self.address() >  other.address()
        elif op == 5: return self.address() >= other.address()

        else: assert 0

    def __nonzero__(self):
        return xl_clock_get_int(self.clock, XL_CLOCK_PROPERTY_OPEN)

    def __reduce__(self):
        cdef bytes b = b'\0' * xl_clock_buffer_size(self.clock)
        cdef char* p = <char*>b

        xl_clock_buffer_save(<u8*>p, self.clock)
        return (self.__class__, (None, ), b)

    def __setstate__(self, bytes state):
        self.clock = xl_clock_buffer_load(<u8*>(<char*>state), len(state))

    def __copy__(self):
        return self.__class__(reference=<size_t>xl_clock_copy(self.clock))

    copy = __copy__

    def __call__(self, *a, **k):
        return self.get_timer(*a, **k)

    @staticmethod
    def print_all(): return xl_clock_print_all()

    @staticmethod
    def count_all(): return xl_clock_count_all()

    @classmethod
    def list_all(cls):
        """
        Gather references to all open, active, valid clocks in a single list.
        """
        cdef xl_clock_t* clocks[2048]
        cdef int i
        cdef list objects = []

        if xl_clock_count_all() > 2048:
            raise MemoryError("too many open clocks for temp")

        xl_clock_list_all(clocks)

        for i in range(<int>xl_clock_count_all()):
            objects.append(cls(reference = <size_t>clocks[i]))

        return objects

    @staticmethod
    def close_all(): xl_clock_close_all()

    property id:
        def __get__(self):
            return xl_clock_get_int(self.clock, XL_CLOCK_PROPERTY_ID)

    property num_timers:
        def __get__(self):
            return xl_clock_get_int(self.clock, XL_CLOCK_PROPERTY_NUM_TIMERS)

    property dt:
        def __get__(self):
            return xl_clock_get_dbl(self.clock, XL_CLOCK_PROPERTY_DT)

    property fps:
        def __get__(self):
            return xl_clock_get_dbl(self.clock, XL_CLOCK_PROPERTY_FPS)

    property auto_update:
        def __get__(self):
            return xl_clock_get_int(self.clock, XL_CLOCK_PROPERTY_AUTO_UPDATE)

        def __set__(self, bint value):
            xl_clock_set_int(self.clock, XL_CLOCK_PROPERTY_AUTO_UPDATE, value)

    property paused:
        def __get__(self):
            return xl_clock_get_int(self.clock, XL_CLOCK_PROPERTY_PAUSED)

        def __set__(self, bint value):
            xl_clock_set_int(self.clock, XL_CLOCK_PROPERTY_PAUSED, value)

    property status:
        def __get__(self):
            cdef bytes s = xl_clock_get_str(self.clock, XL_CLOCK_PROPERTY_STATUS)
            return s.decode() if sys.version_info.major > 2 else s

        def __set__(self, str value):
            cdef bytes string

            if sys.version_info.major > 2:
                string = <bytes>value.encode('utf-8')
            else:
                string = <bytes>value

            xl_clock_set_str(self.clock, XL_CLOCK_PROPERTY_STATUS, <char*>string)

    property name:
        def __get__(self):
            cdef bytes s = xl_clock_get_str(self.clock, XL_CLOCK_PROPERTY_NAME)
            return s.decode() if sys.version_info.major > 2 else s

        def __set__(self, str value):
            cdef bytes string

            if sys.version_info.major > 2:
                string = <bytes>value.encode('utf-8')
            else:
                string = <bytes>value

            xl_clock_set_str(self.clock, XL_CLOCK_PROPERTY_NAME, <char*>string)

    property open:
        def __get__(self):
            return xl_clock_get_int(self.clock, XL_CLOCK_PROPERTY_OPEN)

        def __set__(self, bint value):
            xl_clock_set_int(self.clock, XL_CLOCK_PROPERTY_OPEN, value)

    def address(self):
        return <size_t>self.clock

    def cast(self):
        return self

    def close(self):
        xl_clock_close(self.clock); return self

    @staticmethod
    def update_all(double dt):
        """
        Update all open clock objects by a given time delta (usually frame time).
        """
        xl_clock_update_all(dt)

    def update(self, double dt):
        """
        Update this clock object by a given time delta (usually frame time).
        """
        xl_clock_update(self.clock, dt); return self

    def add_timer(self, str name, double seconds, bint repeat):
        cdef bytes b

        if sys.version_info.major > 2:
            b = <bytes>name.encode('utf-8')
        else:
            b = <bytes>name

        xl_clock_add_timer(self.clock, <const char*>b, seconds, repeat)
        return self

    def remove_timer(self, str name):
        cdef bytes b

        if sys.version_info.major > 2:
            b = <bytes>name.encode('utf-8')
        else:
            b = <bytes>name

        xl_clock_remove_timer(self.clock, <const char*>b); return self

    def remove_all_timers(self):
        xl_clock_remove_all_timers(self.clock); return self

    def get_timer(self, str name):
        cdef bytes b

        cdef double current
        cdef double seconds

        cdef int paused
        cdef int repeat

        if sys.version_info.major > 2:
            b = <bytes>name.encode('utf-8')
        else:
            b = <bytes>name

        if xl_clock_get_timer(self.clock, <const char *>b, &current,
                                        &seconds, &paused, &repeat):
            return {
                'name': name,
                'current': current,
                'seconds': seconds,
                'paused': paused,
                'repeat': repeat,
            }

    def get_all_timers(self):
        cdef bytes b
        cdef list ls = []

        cdef int n = xl_clock_get_int(self.clock, XL_CLOCK_PROPERTY_NUM_TIMERS)
        cdef int i
        cdef char** names = xl_clock_copy_timer_names(self.clock)

        for i in range(n):
            b = <bytes>names[i]
            ls.append(self.get_timer(b.decode() if sys.version_info.major > 2 else b))

        xl_clock_free_timer_names(self.clock, names)
        return ls

    def set_timer_current(self, str name, double value):
        cdef bytes b

        if sys.version_info.major > 2:
            b = <bytes>name.encode('utf-8')
        else:
            b = <bytes>name

        xl_clock_set_timer_current(self.clock, <const char*>b, value)
        return self

    def set_timer_seconds(self, str name, double value):
        cdef bytes b

        if sys.version_info.major > 2:
            b = <bytes>name.encode('utf-8')
        else:
            b = <bytes>name

        xl_clock_set_timer_seconds(self.clock, <const char*>b, value)
        return self

    def set_timer_paused(self, str name, bint value):
        cdef bytes b

        if sys.version_info.major > 2:
            b = <bytes>name.encode('utf-8')
        else:
            b = <bytes>name

        xl_clock_set_timer_paused(self.clock, <const char*>b, value)
        return self

    def set_timer_repeat(self, str name, bint value):
        cdef bytes b

        if sys.version_info.major > 2:
            b = <bytes>name.encode('utf-8')
        else:
            b = <bytes>name

        xl_clock_set_timer_repeat(self.clock, <const char*>b, value)
        return self

    def set_timer_name(self, str old_name, str new_name):
        cdef bytes old_s
        cdef bytes new_s

        if sys.version_info.major > 2:
            old_s = <bytes>old_name.encode('utf-8')
            new_s = <bytes>new_name.encode('utf-8')
        else:
            old_s = <bytes>old_name
            new_s = <bytes>new_name

        xl_clock_set_timer_name(self.clock, <const char*>old_s,
                                            <const char*>new_s)
        return self

# ==============================================================================
# ~ [ timed events ]
# ==============================================================================

class timer(object):
    """
    Interface to the timed event system. All timer names must be unique.
    """
    @staticmethod
    def register(str name, double seconds, bint repeat):
        cdef bytes b

        if sys.version_info.major > 2:
            b = <bytes>name.encode('utf-8')
        else:
            b = <bytes>name

        xl_timer_register(<const char*>b, seconds, repeat)

    @staticmethod
    def unregister(str name):
        cdef bytes b

        if sys.version_info.major > 2:
            b = <bytes>name.encode('utf-8')
        else:
            b = <bytes>name

        xl_timer_unregister(<const char*>b)

    @staticmethod
    def get(str name):
        """
        Retrieve the current state of the timer, for fading effects etc.
        """
        cdef bytes b

        cdef double current
        cdef double seconds

        cdef int repeat

        if sys.version_info.major > 2:
            b = <bytes>name.encode('utf-8')
        else:
            b = <bytes>name

        if xl_timer_get(<const char*>b, &current, &seconds, &repeat):
            return {
                'name': name,
                'current': current,
                'seconds': seconds,
                'repeat': repeat,
            }

    @staticmethod
    def set_repeat(str name, int repeat):
        """
        Used for finishing timers without immediately unregistering them.
        """
        cdef bytes b

        if sys.version_info.major > 2:
            b = <bytes>name.encode('utf-8')
        else:
            b = <bytes>name

        xl_timer_set_repeat(<const char*>b, repeat)

# ==============================================================================
# ~ [ event handling ]
# ==============================================================================

class event(object):
    """
    Interface to the system event queue that notifies us on events like a window
    being resized, or a controller being plugged in. The user can dispatch events
    to an event handler object, and/or iterate through events in a Python list.
    """
    @staticmethod
    def count_pending():
        """
        Count the number of events we haven't processed yet with dispatch or poll.
        """
        return xl_event_count_pending()

    @staticmethod
    def poll(bint wait=False):
        """
        Grab a single event from the pump, optionally blocking until a new event
        (for tools that want to save power by only updating on user interaction).
        """
        cdef bytes name

        cdef Controller controller = Controller(reference=0)
        cdef Mouse mouse = Mouse(reference=0)
        cdef Keyboard keyboard = Keyboard(reference=0)
        cdef Sound sound = Sound(reference=0)
        cdef Window window = Window(reference=0)
        cdef Animation animation = Animation(reference=0)
        cdef Clock clock = Clock(reference=0)

        cdef xl_event_type_t c_type
        cdef xl_event_t c_event

        xl_event_poll(&c_event, wait)
        c_type = c_event.type

        # NOTE: now we have to manually translate c structures to python tuples

        if c_type == XL_EVENT_NOTHING:
            return None

        elif c_type == XL_EVENT_QUIT:
            return ('quit',)

        elif c_type == XL_EVENT_WINDOW_CLOSE:
            window.window = c_event.as_window_close.window

            return ('window_close', window)

        elif c_type == XL_EVENT_WINDOW_MOVE:
            window.window = c_event.as_window_move.window

            return ('window_move', window,
                c_event.as_window_move.x, c_event.as_window_move.y)

        elif c_type == XL_EVENT_WINDOW_RESIZE:
            window.window = c_event.as_window_resize.window

            return ('window_resize', window,
                c_event.as_window_resize.width, c_event.as_window_resize.height)

        elif c_type == XL_EVENT_WINDOW_VISIBILITY_CHANGE:
            window.window = c_event.as_window_visibility_change.window

            return ('window_visibility_change', window,
                    bool(c_event.as_window_visibility_change.visible))

        elif c_type == XL_EVENT_WINDOW_REDRAW:
            window.window = c_event.as_window_redraw.window

            return ('window_redraw', window)

        elif c_type == XL_EVENT_WINDOW_GAIN_FOCUS:
            window.window = c_event.as_window_gain_focus.window

            return ('window_gain_focus', window)

        elif c_type == XL_EVENT_WINDOW_LOSE_FOCUS:
            window.window = c_event.as_window_lose_focus.window

            return ('window_lose_focus', window)

        elif c_type == XL_EVENT_WINDOW_MOUSE_ENTER:
            window.window = c_event.as_window_mouse_enter.window
            mouse.mouse = c_event.as_window_mouse_enter.mouse

            return ('window_mouse_enter', window, mouse)

        elif c_type == XL_EVENT_WINDOW_MOUSE_LEAVE:
            window.window = c_event.as_window_mouse_leave.window
            mouse.mouse = c_event.as_window_mouse_leave.mouse

            return ('window_mouse_leave', window, mouse)

        elif c_type == XL_EVENT_MUSIC_FINISHED:
            return ('music_finished',)

        elif c_type == XL_EVENT_SOUND_FINISHED:
            sound.sound = c_event.as_sound_finished.sound

            return ('sound_finished', sound)

        elif c_type == XL_EVENT_ANIMATION_FINISHED:
            animation.animation = c_event.as_animation_finished.animation

            return ('animation_finished', animation)

        elif c_type == XL_EVENT_KEYBOARD_INSERT:
            keyboard.keyboard = c_event.as_keyboard_insert.keyboard

            return ('keyboard_insert', keyboard)

        elif c_type == XL_EVENT_KEYBOARD_REMOVE:
            keyboard.keyboard = c_event.as_keyboard_remove.keyboard

            return ('keyboard_remove', keyboard)

        elif c_type == XL_EVENT_KEYBOARD_KEY:
            name = xl_keyboard_key_short_name[<size_t>c_event.as_keyboard_key.key]
            keyboard.keyboard = c_event.as_keyboard_key.keyboard

            return ('keyboard_key', keyboard,
                    Keyboard._mod_list(c_event.as_keyboard_key.mods),
                    name.decode() if sys.version_info.major > 2 else name,
                    bool(c_event.as_keyboard_key.pressed))

        elif c_type == XL_EVENT_MOUSE_INSERT:
            mouse.mouse = c_event.as_mouse_insert.mouse

            return ('mouse_insert', mouse)

        elif c_type == XL_EVENT_MOUSE_REMOVE:
            mouse.mouse = c_event.as_mouse_remove.mouse

            return ('mouse_remove', mouse)

        elif c_type == XL_EVENT_MOUSE_BUTTON:
            name = xl_mouse_button_short_name[<size_t>c_event.as_mouse_button.button]
            mouse.mouse = c_event.as_mouse_button.mouse

            return ('mouse_button', mouse,
                    name.decode() if sys.version_info.major > 2 else name,
                    bool(c_event.as_mouse_button.pressed))

        elif c_type == XL_EVENT_MOUSE_WHEEL:
            mouse.mouse = c_event.as_mouse_wheel.mouse

            return ('mouse_wheel', mouse, c_event.as_mouse_wheel.x, c_event.as_mouse_wheel.y)

        elif c_type == XL_EVENT_MOUSE_MOTION:
            mouse.mouse = c_event.as_mouse_motion.mouse
            window.window = c_event.as_mouse_motion.window

            return ('mouse_motion', mouse, window,
                    Mouse._button_list( c_event.as_mouse_motion.buttons ),
                    c_event.as_mouse_motion.x, c_event.as_mouse_motion.y,
                    c_event.as_mouse_motion.dx, c_event.as_mouse_motion.dy)

        elif c_type == XL_EVENT_CONTROLLER_INSERT:
            controller.controller = c_event.as_controller_insert.controller

            return ('controller_insert', controller)

        elif c_type == XL_EVENT_CONTROLLER_REMOVE:
            controller.controller = c_event.as_controller_remove.controller

            return ('controller_remove', controller)

        elif c_type == XL_EVENT_CONTROLLER_BUTTON:
            name = xl_controller_button_short_name[<size_t>c_event.as_controller_button.button]
            controller.controller = c_event.as_controller_button.controller

            return ('controller_button', controller,
                    name.decode() if sys.version_info.major > 2 else name,
                    bool(c_event.as_controller_button.pressed))

        elif c_type == XL_EVENT_CONTROLLER_TRIGGER:
            controller.controller = c_event.as_controller_trigger.controller

            return ('controller_trigger', controller,
                chr(c_event.as_controller_trigger.which), c_event.as_controller_trigger.value)

        elif c_type == XL_EVENT_CONTROLLER_STICK:
            controller.controller = c_event.as_controller_stick.controller

            return ('controller_stick', controller,
                chr(c_event.as_controller_stick.which),

                    c_event.as_controller_stick.magnitude, c_event.as_controller_stick.angle,
                    c_event.as_controller_stick.x, c_event.as_controller_stick.y)

        elif c_type == XL_EVENT_TIMER:
            clock.clock = c_event.as_timer.clock
            name = <bytes>c_event.as_timer.name

            return ('timer', clock,
                    name.decode() if sys.version_info.major > 2 else name,
                    c_event.as_timer.seconds, c_event.as_timer.repeat)

        elif c_type == XL_EVENT_LONG_FRAME:
            return ('long_frame', c_event.as_long_frame.dt)

        assert 0, xl_event_type_name[<size_t>c_type]

    @staticmethod
    def dispatch(object handler, bint wait=False):
        """
        Same as poll, but passes the event to an optional object method.
        """
        cdef tuple py_event = event.poll(wait)

        if py_event is not None:
            attr = getattr(handler, 'on_' + py_event[0], None)

            # NOTE: we can't eat any exceptions that might happen here
            if attr is not None: attr(*py_event[1:])

        return py_event

    @staticmethod
    def dispatch_all(object handler):
        cdef tuple py_event = event.dispatch(handler)
        cdef list results = []

        while py_event:
            results.append(py_event)
            py_event = event.dispatch(handler)

        return results

    @staticmethod
    def poll_all(): return event.dispatch_all(None)

    class LoggingEventHandler(object):
        """
        Example event dispatch target for testing. Prints all events.
        """
        def on_quit(self): raise SystemExit

        def __getattr__(self, name):
            def log_event(*event):
                print name[3:] + (str(event) if len(event) != 1 else
                                        ('(' + str(event[0]) + ')'))
            return log_event

    log_handler = LoggingEventHandler()

    # NOTE: this hack is here to allow this to work with window.run()
    log_handler.has_exit = False
    log_handler.queued_state = None
    log_handler.on_enter = lambda window: None
    log_handler.on_leave = lambda window: None
    log_handler.update = lambda dt: None
    log_handler.draw = lambda window: None
