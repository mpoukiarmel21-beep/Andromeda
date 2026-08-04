#ifndef DYLD_PRIV_H
#define DYLD_PRIV_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>
#include <mach-o/loader.h>
#include <mach-o/dyld_images.h>

typedef void (*dyld_register_func_for_add_image_t)(const struct mach_header* mh, intptr_t vmaddr_slide);
typedef void (*dyld_register_func_for_remove_image_t)(const struct mach_header* mh, intptr_t vmaddr_slide);

extern void _dyld_register_func_for_add_image(dyld_register_func_for_add_image_t func);
extern void _dyld_register_func_for_remove_image(dyld_register_func_for_remove_image_t func);
extern const char* dyld_image_path_containing_address(const void* addr);
extern bool dyld_shared_cache_some_image_overridden(void);
extern int dyld_shared_cache_iterate_text(const struct mach_header* mh, const char* segment_section_name, void (^callback)(const void* bytes, uint32_t off, const void* bytes0, uint32_t off0));

extern uint32_t _dyld_image_count(void);
extern const struct mach_header* _dyld_get_image_header(uint32_t image_index);
extern intptr_t _dyld_get_image_vmaddr_slide(uint32_t image_index);
extern const char* _dyld_get_image_name(uint32_t image_index);
extern bool _dyld_is_memory_immutable(const void* addr, size_t length);

typedef struct dyld_unwind_sections {
    const struct mach_header* mh;
    const void* dwarf_section;
    uintptr_t dwarf_section_length;
    const void* compact_unwind_section;
    uintptr_t compact_unwind_section_length;
} dyld_unwind_sections;

extern bool _dyld_find_unwind_sections(void* addr, dyld_unwind_sections* info);

#ifdef __cplusplus
}
#endif

#endif
