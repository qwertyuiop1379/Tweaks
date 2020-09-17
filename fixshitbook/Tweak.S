.text
.align 4
_count:
	mov x0, xzr
	ret

_init:
	stp x19, x30, [sp, #-0x10]!

	adrp x0, selector@page
	add x0, x0, selector@pageoff
	bl _sel_registerName
	mov x19, x0

	adrp x0, class@page
	add x0, x0, class@pageoff
	bl _objc_getClass

	mov x1, x19
	ldr x2, _count
	adrp x3, types@page
	add x3, x3, types@pageoff
	bl _class_addMethod

	ldp x19, x30, [sp], #0x10
	ret

.section __DATA, __mod_init_func
.long _init

.data
class: .asciz "NSNull"
selector: .asciz "count"
types: .asciz "@:"
