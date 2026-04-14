; ModuleID = 'tools/lx32_backend/tests/baremetal/programs/10_matrix_scan.c'
source_filename = "tools/lx32_backend/tests/baremetal/programs/10_matrix_scan.c"
target datalayout = "e-m:e-p:32:32-p270:32:32-p271:32:32-p272:64:64-i128:128-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i386-unknown-unknown-elf"

; Function Attrs: noinline nounwind optnone
define dso_local void @test_complex_scan() #0 {
  %1 = alloca ptr, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = call ptr @llvm.lx32.matrix(i32 0)
  store ptr %5, ptr %1, align 4
  %6 = call i32 @llvm.lx32.chord(i32 5)
  store i32 %6, ptr %2, align 4
  store i32 0, ptr %3, align 4
  br label %7

7:                                                ; preds = %24, %0
  %8 = load i32, ptr %3, align 4
  %9 = icmp slt i32 %8, 64
  br i1 %9, label %10, label %27

10:                                               ; preds = %7
  %11 = load i32, ptr %3, align 4
  %12 = call i32 @llvm.lx32.delta(i32 %11)
  store i32 %12, ptr %4, align 4
  %13 = load ptr, ptr %1, align 4
  %14 = load i32, ptr %3, align 4
  %15 = getelementptr inbounds i16, ptr %13, i32 %14
  %16 = load i16, ptr %15, align 2
  %17 = zext i16 %16 to i32
  %18 = icmp sgt i32 %17, 2000
  br i1 %18, label %22, label %19

19:                                               ; preds = %10
  %20 = load i32, ptr %4, align 4
  %21 = icmp sgt i32 %20, 100
  br i1 %21, label %22, label %23

22:                                               ; preds = %19, %10
  call void @llvm.lx32.wait(i32 2)
  br label %23

23:                                               ; preds = %22, %19
  br label %24

24:                                               ; preds = %23
  %25 = load i32, ptr %3, align 4
  %26 = add nsw i32 %25, 1
  store i32 %26, ptr %3, align 4
  br label %7, !llvm.loop !3

27:                                               ; preds = %7
  %28 = load ptr, ptr %1, align 4
  call void @llvm.lx32.report(ptr %28)
  ret void
}

; Function Attrs: nounwind memory(none)
declare ptr @llvm.lx32.matrix(i32) #1

; Function Attrs: nounwind memory(none)
declare i32 @llvm.lx32.chord(i32) #1

; Function Attrs: nounwind memory(none)
declare i32 @llvm.lx32.delta(i32) #1

; Function Attrs: nounwind
declare void @llvm.lx32.wait(i32) #2

; Function Attrs: nounwind
declare void @llvm.lx32.report(ptr) #2

attributes #0 = { noinline nounwind optnone "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="" "tune-cpu"="generic" }
attributes #1 = { nounwind memory(none) }
attributes #2 = { nounwind }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"NumRegisterParameters", i32 0}
!1 = !{i32 7, !"frame-pointer", i32 2}
!2 = !{!"clang version 23.0.0git (https://github.com/Axel84727/llvm-project-lx32.git 1124aa5a463f0d88df752564ca79023d0f690e60)"}
!3 = distinct !{!3, !4}
!4 = !{!"llvm.loop.mustprogress"}
