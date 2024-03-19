#include <asm/desc.h>

void my_store_idt(struct desc_ptr *idtr) {
    asm volatile("sidt %0;":"=m"(*idtr)::); // Store IDT into memory pointed to by *idtr
}
void my_load_idt(struct desc_ptr *idtr) {
    asm volatile("lidt %0;"::"m"(*idtr):); // load IDT from memory pointed to by *idtr
}

void my_set_gate_offset(gate_desc *gate, unsigned long addr) {
    gate->offset_low = addr; // low is first 2 bytes
    gate->offset_middle = addr >> 16; // middle is second 2 bytes so we shift 16 to the right
    gate->offset_high = addr >> 32; // high is last 4 bytes so we shift 32 times to the right
}

unsigned long my_get_gate_offset(gate_desc *gate) {
    unsigned long my_offset = gate->offset_high;
    my_offset = my_offset << 16; // Shift to the left 16 times
    my_offset += gate->offset_middle;
    my_offset = my_offset << 16; // Shift to the left 16 times
    my_offset += gate->offset_low;
    return my_offset;
}
