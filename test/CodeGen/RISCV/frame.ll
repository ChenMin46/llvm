; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32I-FPELIM %s
; RUN: llc -mtriple=riscv32 -disable-fp-elim -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32I-WITHFP %s

%struct.key_t = type { i32, [16 x i8] }

define i32 @test() nounwind {
; RV32I-FPELIM-LABEL: test:
; RV32I-FPELIM:       # %bb.0:
; RV32I-FPELIM-NEXT:    addi sp, sp, -32
; RV32I-FPELIM-NEXT:    sw ra, 28(sp)
; RV32I-FPELIM-NEXT:    sw zero, 24(sp)
; RV32I-FPELIM-NEXT:    sw zero, 20(sp)
; RV32I-FPELIM-NEXT:    sw zero, 16(sp)
; RV32I-FPELIM-NEXT:    sw zero, 12(sp)
; RV32I-FPELIM-NEXT:    sw zero, 8(sp)
; RV32I-FPELIM-NEXT:    lui a0, %hi(test1)
; RV32I-FPELIM-NEXT:    addi a1, a0, %lo(test1)
; RV32I-FPELIM-NEXT:    addi a0, sp, 12
; RV32I-FPELIM-NEXT:    jalr a1
; RV32I-FPELIM-NEXT:    mv a0, zero
; RV32I-FPELIM-NEXT:    lw ra, 28(sp)
; RV32I-FPELIM-NEXT:    addi sp, sp, 32
; RV32I-FPELIM-NEXT:    ret
;
; RV32I-WITHFP-LABEL: test:
; RV32I-WITHFP:       # %bb.0:
; RV32I-WITHFP-NEXT:    addi sp, sp, -32
; RV32I-WITHFP-NEXT:    sw ra, 28(sp)
; RV32I-WITHFP-NEXT:    sw s0, 24(sp)
; RV32I-WITHFP-NEXT:    addi s0, sp, 32
; RV32I-WITHFP-NEXT:    sw zero, -16(s0)
; RV32I-WITHFP-NEXT:    sw zero, -20(s0)
; RV32I-WITHFP-NEXT:    sw zero, -24(s0)
; RV32I-WITHFP-NEXT:    sw zero, -28(s0)
; RV32I-WITHFP-NEXT:    sw zero, -32(s0)
; RV32I-WITHFP-NEXT:    lui a0, %hi(test1)
; RV32I-WITHFP-NEXT:    addi a1, a0, %lo(test1)
; RV32I-WITHFP-NEXT:    addi a0, s0, -28
; RV32I-WITHFP-NEXT:    jalr a1
; RV32I-WITHFP-NEXT:    mv a0, zero
; RV32I-WITHFP-NEXT:    lw s0, 24(sp)
; RV32I-WITHFP-NEXT:    lw ra, 28(sp)
; RV32I-WITHFP-NEXT:    addi sp, sp, 32
; RV32I-WITHFP-NEXT:    ret
  %key = alloca %struct.key_t, align 4
  %1 = bitcast %struct.key_t* %key to i8*
  call void @llvm.memset.p0i8.i64(i8* %1, i8 0, i64 20, i32 4, i1 false)
  %2 = getelementptr inbounds %struct.key_t, %struct.key_t* %key, i64 0, i32 1, i64 0
  call void @test1(i8* %2) #3
  ret i32 0
}

declare void @llvm.memset.p0i8.i64(i8* nocapture, i8, i64, i32, i1)

declare void @test1(i8*)
