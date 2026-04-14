; ModuleID = 'tools/lx32_backend/tests/baremetal/programs/11_run_custom_intrinsics.c'
source_filename = "tools/lx32_backend/tests/baremetal/programs/11_run_custom_intrinsics.c"
target datalayout = "e-m:e-p:32:32-p270:32:32-p271:32:32-p272:64:64-i128:128-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i386-unknown-unknown-elf"

; Function Attrs: noinline nounwind optnone
define dso_local void @test_pulsar_custom_isa() #0 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = call i32 @llvm.lx32.sensor(i32 3)
  store volatile i32 %5, ptr %1, align 4
  %6 = call ptr @llvm.lx32.matrix(i32 0)
  store ptr %6, ptr %2, align 4
  %7 = call i32 @llvm.lx32.delta(i32 42)
  store volatile i32 %7, ptr %3, align 4
  %8 = call i32 @llvm.lx32.chord(i32 42)
  store volatile i32 %8, ptr %4, align 4
  call void @llvm.lx32.wait(i32 10)
  %9 = load ptr, ptr %2, align 4
  call void @llvm.lx32.report(ptr %9)
  ret void
}

; Function Attrs: nounwind memory(none)
declare i32 @llvm.lx32.sensor(i32) #1

; Function Attrs: nounwind memory(none)
declare ptr @llvm.lx32.matrix(i32) #1

; Function Attrs: nounwind memory(none)
declare i32 @llvm.lx32.delta(i32) #1

; Function Attrs: nounwind memory(none)
declare i32 @llvm.lx32.chord(i32) #1

; Function Attrs: nounwind
declare void @llvm.lx32.wait(i32) #2

; Function Attrs: nounwind
declare void @llvm.lx32.report(ptr) #2

; Function Attrs: noinline nounwind optnone
define dso_local i32 @main() #0 {
  call void @test_pulsar_custom_isa() #3
  ret i32 0
}

attributes #0 = { noinline nounwind optnone "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="" "tune-cpu"="generic" }
attributes #1 = { nounwind memory(none) }
attributes #2 = { nounwind }
attributes #3 = { nobuiltin "no-builtins" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"NumRegisterParameters", i32 0}
!1 = !{i32 7, !"frame-pointer", i32 2}
!2 = !{!"clang version 23.0.0git (https://github.com/Axel84727/llvm-project-lx32.git 1124aa5a463f0d88df752564ca79023d0f690e60)"}
