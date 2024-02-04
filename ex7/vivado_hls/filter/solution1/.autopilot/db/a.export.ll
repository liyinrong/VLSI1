; ModuleID = '/home/vlsi1_010hs23/ex7/vivado_hls/filter/solution1/.autopilot/db/a.o.2.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@y_loop_x_loop_str = internal unnamed_addr constant [14 x i8] c"y_loop_x_loop\00"
@window_r_V_2_2 = internal unnamed_addr global i8 0
@window_r_V_2_1 = internal unnamed_addr global i8 0
@window_r_V_1_2 = internal unnamed_addr global i8 0
@window_r_V_1_1 = internal unnamed_addr global i8 0
@window_r_V_0_2 = internal unnamed_addr global i8 0
@window_r_V_0_1 = internal unnamed_addr global i8 0
@window_g_V_2_2 = internal unnamed_addr global i8 0
@window_g_V_2_1 = internal unnamed_addr global i8 0
@window_g_V_1_2 = internal unnamed_addr global i8 0
@window_g_V_1_1 = internal unnamed_addr global i8 0
@window_g_V_0_2 = internal unnamed_addr global i8 0
@window_g_V_0_1 = internal unnamed_addr global i8 0
@window_b_V_2_2 = internal unnamed_addr global i8 0
@window_b_V_2_1 = internal unnamed_addr global i8 0
@window_b_V_1_2 = internal unnamed_addr global i8 0
@window_b_V_1_1 = internal unnamed_addr global i8 0
@window_b_V_0_2 = internal unnamed_addr global i8 0
@window_b_V_0_1 = internal unnamed_addr global i8 0
@llvm_global_ctors_1 = appending global [1 x void ()*] [void ()* @_GLOBAL__I_a]
@llvm_global_ctors_0 = appending global [1 x i32] [i32 65535]
@lines_r_V_1 = internal unnamed_addr global [1920 x i8] zeroinitializer
@lines_r_V_0 = internal unnamed_addr global [1920 x i8] zeroinitializer
@lines_g_V_1 = internal unnamed_addr global [1920 x i8] zeroinitializer
@lines_g_V_0 = internal unnamed_addr global [1920 x i8] zeroinitializer
@lines_b_V_1 = internal unnamed_addr global [1920 x i8] zeroinitializer
@lines_b_V_0 = internal unnamed_addr global [1920 x i8] zeroinitializer
@filter_hls_str = internal unnamed_addr constant [11 x i8] c"filter_hls\00"
@p_str6 = private unnamed_addr constant [7 x i8] c"x_loop\00", align 1
@p_str4 = private unnamed_addr constant [5 x i8] c"both\00", align 1
@p_str3 = private unnamed_addr constant [5 x i8] c"axis\00", align 1
@p_str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

declare i24 @llvm.part.select.i24(i24, i32, i32) nounwind readnone

declare i20 @llvm.part.select.i20(i20, i32, i32) nounwind readnone

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

define void @filter_hls(i24* %data_in, i24* %data_out) {
.preheader43.preheader:
  call void (...)* @_ssdm_op_SpecBitsMap(i24* %data_out), !map !97
  call void (...)* @_ssdm_op_SpecBitsMap(i24* %data_in), !map !107
  call void (...)* @_ssdm_op_SpecTopModule([11 x i8]* @filter_hls_str) nounwind
  call void (...)* @_ssdm_op_SpecInterface(i24* %data_in, [5 x i8]* @p_str3, i32 1, i32 1, [5 x i8]* @p_str4, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str) nounwind
  call void (...)* @_ssdm_op_SpecInterface(i24* %data_out, [5 x i8]* @p_str3, i32 1, i32 1, [5 x i8]* @p_str4, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str) nounwind
  %window_r_V_0_2_load = load i8* @window_r_V_0_2, align 1
  %window_g_V_0_2_load = load i8* @window_g_V_0_2, align 1
  %window_b_V_0_2_load = load i8* @window_b_V_0_2, align 1
  %window_r_V_1_2_load = load i8* @window_r_V_1_2, align 1
  %window_g_V_1_2_load = load i8* @window_g_V_1_2, align 1
  %window_b_V_1_2_load = load i8* @window_b_V_1_2, align 1
  %window_r_V_2_2_load = load i8* @window_r_V_2_2, align 1
  %window_g_V_2_2_load = load i8* @window_g_V_2_2, align 1
  %window_b_V_2_2_load = load i8* @window_b_V_2_2, align 1
  br label %0

; <label>:0                                       ; preds = %.preheader43.preheader, %._crit_edge51
  %indvar_flatten = phi i21 [ 0, %.preheader43.preheader ], [ %indvar_flatten_next, %._crit_edge51 ]
  %y = phi i11 [ 0, %.preheader43.preheader ], [ %y_mid2, %._crit_edge51 ]
  %window_r_V_0_2_loc_1 = phi i8 [ %window_r_V_0_2_load, %.preheader43.preheader ], [ %window_r_V_0_2_loc_2, %._crit_edge51 ]
  %window_g_V_0_2_loc_1 = phi i8 [ %window_g_V_0_2_load, %.preheader43.preheader ], [ %window_g_V_0_2_loc_2, %._crit_edge51 ]
  %window_b_V_0_2_loc_1 = phi i8 [ %window_b_V_0_2_load, %.preheader43.preheader ], [ %window_b_V_0_2_loc_2, %._crit_edge51 ]
  %window_r_V_1_2_loc_1 = phi i8 [ %window_r_V_1_2_load, %.preheader43.preheader ], [ %window_r_V_1_2_loc_2, %._crit_edge51 ]
  %window_g_V_1_2_loc_1 = phi i8 [ %window_g_V_1_2_load, %.preheader43.preheader ], [ %window_g_V_1_2_loc_2, %._crit_edge51 ]
  %window_b_V_1_2_loc_1 = phi i8 [ %window_b_V_1_2_load, %.preheader43.preheader ], [ %window_b_V_1_2_loc_2, %._crit_edge51 ]
  %window_r_V_2_2_loc_1 = phi i8 [ %window_r_V_2_2_load, %.preheader43.preheader ], [ %window_r_V_2_2_loc_2, %._crit_edge51 ]
  %window_g_V_2_2_loc_1 = phi i8 [ %window_g_V_2_2_load, %.preheader43.preheader ], [ %window_g_V_2_2_loc_2, %._crit_edge51 ]
  %window_b_V_2_2_loc_1 = phi i8 [ %window_b_V_2_2_load, %.preheader43.preheader ], [ %window_b_V_2_2_loc_2, %._crit_edge51 ]
  %x = phi i11 [ 0, %.preheader43.preheader ], [ %x_1, %._crit_edge51 ]
  %tmp_1 = icmp ult i11 %y, -968
  %tmp_3 = icmp ne i11 %y, 0
  %exitcond_flatten = icmp eq i21 %indvar_flatten, -20551
  %indvar_flatten_next = add i21 %indvar_flatten, 1
  br i1 %exitcond_flatten, label %4, label %.reset

.preheader38.preheader:                           ; preds = %.reset
  %tmp_7 = zext i11 %x_mid2 to i64
  %lines_r_V_0_addr = getelementptr [1920 x i8]* @lines_r_V_0, i64 0, i64 %tmp_7
  %lines_r_V_0_load = load i8* %lines_r_V_0_addr, align 1
  store i8 %lines_r_V_0_load, i8* @window_r_V_0_2, align 1
  %lines_g_V_0_addr = getelementptr [1920 x i8]* @lines_g_V_0, i64 0, i64 %tmp_7
  %lines_g_V_0_load = load i8* %lines_g_V_0_addr, align 1
  store i8 %lines_g_V_0_load, i8* @window_g_V_0_2, align 1
  %lines_b_V_0_addr = getelementptr [1920 x i8]* @lines_b_V_0, i64 0, i64 %tmp_7
  %lines_b_V_0_load = load i8* %lines_b_V_0_addr, align 1
  store i8 %lines_b_V_0_load, i8* @window_b_V_0_2, align 1
  %lines_r_V_1_addr = getelementptr [1920 x i8]* @lines_r_V_1, i64 0, i64 %tmp_7
  %lines_r_V_1_load = load i8* %lines_r_V_1_addr, align 1
  store i8 %lines_r_V_1_load, i8* @window_r_V_1_2, align 1
  %lines_g_V_1_addr = getelementptr [1920 x i8]* @lines_g_V_1, i64 0, i64 %tmp_7
  %lines_g_V_1_load = load i8* %lines_g_V_1_addr, align 1
  store i8 %lines_g_V_1_load, i8* @window_g_V_1_2, align 1
  %lines_b_V_1_addr = getelementptr [1920 x i8]* @lines_b_V_1, i64 0, i64 %tmp_7
  %lines_b_V_1_load = load i8* %lines_b_V_1_addr, align 1
  store i8 %lines_b_V_1_load, i8* @window_b_V_1_2, align 1
  store i8 %lines_r_V_1_load, i8* %lines_r_V_0_addr, align 1
  store i8 %lines_g_V_1_load, i8* %lines_g_V_0_addr, align 1
  store i8 %lines_b_V_1_load, i8* %lines_b_V_0_addr, align 1
  br label %.loopexit

.preheader.0:                                     ; preds = %.reset
  store i8 0, i8* @window_r_V_0_2, align 1
  store i8 0, i8* @window_g_V_0_2, align 1
  store i8 0, i8* @window_b_V_0_2, align 1
  store i8 0, i8* @window_r_V_1_2, align 1
  store i8 0, i8* @window_g_V_1_2, align 1
  store i8 0, i8* @window_b_V_1_2, align 1
  br label %.loopexit

.loopexit:                                        ; preds = %.preheader.0, %.preheader38.preheader
  %window_r_V_0_2_loc_2 = phi i8 [ %lines_r_V_0_load, %.preheader38.preheader ], [ 0, %.preheader.0 ]
  %window_g_V_0_2_loc_2 = phi i8 [ %lines_g_V_0_load, %.preheader38.preheader ], [ 0, %.preheader.0 ]
  %window_b_V_0_2_loc_2 = phi i8 [ %lines_b_V_0_load, %.preheader38.preheader ], [ 0, %.preheader.0 ]
  %window_r_V_1_2_loc_2 = phi i8 [ %lines_r_V_1_load, %.preheader38.preheader ], [ 0, %.preheader.0 ]
  %window_g_V_1_2_loc_2 = phi i8 [ %lines_g_V_1_load, %.preheader38.preheader ], [ 0, %.preheader.0 ]
  %window_b_V_1_2_loc_2 = phi i8 [ %lines_b_V_1_load, %.preheader38.preheader ], [ 0, %.preheader.0 ]
  %or_cond = and i1 %tmp_5, %tmp_1_mid2
  br i1 %or_cond, label %1, label %2

; <label>:1                                       ; preds = %.loopexit
  %data_in_read = call i24 @_ssdm_op_Read.axis.volatile.i24P(i24* %data_in)
  %tmp_2 = trunc i24 %data_in_read to i8
  %data_in_g_V_load_new = call i8 @_ssdm_op_PartSelect.i8.i24.i32.i32(i24 %data_in_read, i32 8, i32 15)
  %data_in_b_V_load_new = call i8 @_ssdm_op_PartSelect.i8.i24.i32.i32(i24 %data_in_read, i32 16, i32 23)
  store i8 %tmp_2, i8* @window_r_V_2_2, align 2
  store i8 %data_in_g_V_load_new, i8* @window_g_V_2_2, align 1
  store i8 %data_in_b_V_load_new, i8* @window_b_V_2_2, align 2
  %tmp_8 = zext i11 %x_mid2 to i64
  %lines_r_V_1_addr_1 = getelementptr [1920 x i8]* @lines_r_V_1, i64 0, i64 %tmp_8
  store i8 %tmp_2, i8* %lines_r_V_1_addr_1, align 1
  %lines_g_V_1_addr_1 = getelementptr [1920 x i8]* @lines_g_V_1, i64 0, i64 %tmp_8
  store i8 %data_in_g_V_load_new, i8* %lines_g_V_1_addr_1, align 1
  %lines_b_V_1_addr_1 = getelementptr [1920 x i8]* @lines_b_V_1, i64 0, i64 %tmp_8
  store i8 %data_in_b_V_load_new, i8* %lines_b_V_1_addr_1, align 1
  br label %3

; <label>:2                                       ; preds = %.loopexit
  store i8 0, i8* @window_r_V_2_2, align 2
  store i8 0, i8* @window_g_V_2_2, align 1
  store i8 0, i8* @window_b_V_2_2, align 2
  br label %3

; <label>:3                                       ; preds = %2, %1
  %window_r_V_2_2_loc_2 = phi i8 [ %tmp_2, %1 ], [ 0, %2 ]
  %window_g_V_2_2_loc_2 = phi i8 [ %data_in_g_V_load_new, %1 ], [ 0, %2 ]
  %window_b_V_2_2_loc_2 = phi i8 [ %data_in_b_V_load_new, %1 ], [ 0, %2 ]
  %tmp_9 = icmp ne i11 %x_mid2, 0
  %or_cond1 = and i1 %tmp_9, %tmp_3_mid2
  br i1 %or_cond1, label %.preheader.preheader.i.0_ifconv, label %._crit_edge51

.preheader.preheader.i.0_ifconv:                  ; preds = %3
  %p_Val2_s = call i15 @_ssdm_op_BitConcatenate.i15.i8.i7(i8 %window_r_V_0_1_load, i7 0)
  %p_Val2_11_cast = zext i15 %p_Val2_s to i17
  %p_Val2_4 = call i15 @_ssdm_op_BitConcatenate.i15.i8.i7(i8 %window_g_V_0_1_load, i7 0)
  %p_Val2_4_cast = zext i15 %p_Val2_4 to i17
  %p_Val2_7 = call i15 @_ssdm_op_BitConcatenate.i15.i8.i7(i8 %window_b_V_0_1_load, i7 0)
  %p_Val2_7_cast = zext i15 %p_Val2_7 to i17
  %p_Val2_1_0_1 = call i16 @_ssdm_op_BitConcatenate.i16.i8.i8(i8 %window_r_V_0_2_loc_1, i8 0)
  %p_Val2_1_0_1_cast = zext i16 %p_Val2_1_0_1 to i20
  %p_Val2_4_0_1 = call i16 @_ssdm_op_BitConcatenate.i16.i8.i8(i8 %window_g_V_0_2_loc_1, i8 0)
  %p_Val2_4_0_1_cast = zext i16 %p_Val2_4_0_1 to i20
  %p_Val2_7_0_1 = call i16 @_ssdm_op_BitConcatenate.i16.i8.i8(i8 %window_b_V_0_2_loc_1, i8 0)
  %p_Val2_7_0_1_cast = zext i16 %p_Val2_7_0_1 to i20
  %p_Val2_1_0_2 = call i15 @_ssdm_op_BitConcatenate.i15.i8.i7(i8 %window_r_V_0_2_loc_2, i7 0)
  %p_Val2_1_0_2_cast = zext i15 %p_Val2_1_0_2 to i18
  %p_Val2_4_0_2 = call i15 @_ssdm_op_BitConcatenate.i15.i8.i7(i8 %window_g_V_0_2_loc_2, i7 0)
  %p_Val2_4_0_2_cast = zext i15 %p_Val2_4_0_2 to i18
  %p_Val2_7_0_2 = call i15 @_ssdm_op_BitConcatenate.i15.i8.i7(i8 %window_b_V_0_2_loc_2, i7 0)
  %p_Val2_7_0_2_cast = zext i15 %p_Val2_7_0_2 to i18
  %p_Val2_1_1 = call i16 @_ssdm_op_BitConcatenate.i16.i8.i8(i8 %window_r_V_1_1_load, i8 0)
  %p_Val2_1_1_cast = zext i16 %p_Val2_1_1 to i17
  %p_Val2_4_1 = call i16 @_ssdm_op_BitConcatenate.i16.i8.i8(i8 %window_g_V_1_1_load, i8 0)
  %p_Val2_4_1_cast = zext i16 %p_Val2_4_1 to i17
  %p_Val2_7_1 = call i16 @_ssdm_op_BitConcatenate.i16.i8.i8(i8 %window_b_V_1_1_load, i8 0)
  %p_Val2_7_1_cast = zext i16 %p_Val2_7_1 to i17
  %p_shl2 = call i19 @_ssdm_op_BitConcatenate.i19.i8.i11(i8 %window_r_V_1_2_loc_1, i11 0)
  %p_shl2_cast = zext i19 %p_shl2 to i20
  %p_shl3 = call i17 @_ssdm_op_BitConcatenate.i17.i8.i9(i8 %window_r_V_1_2_loc_1, i9 0)
  %p_shl3_cast = zext i17 %p_shl3 to i20
  %p_Val2_1_1_1 = sub i20 %p_shl3_cast, %p_shl2_cast
  %p_shl4 = call i19 @_ssdm_op_BitConcatenate.i19.i8.i11(i8 %window_g_V_1_2_loc_1, i11 0)
  %p_shl4_cast = zext i19 %p_shl4 to i20
  %p_shl5 = call i17 @_ssdm_op_BitConcatenate.i17.i8.i9(i8 %window_g_V_1_2_loc_1, i9 0)
  %p_shl5_cast = zext i17 %p_shl5 to i20
  %p_Val2_4_1_1 = sub i20 %p_shl5_cast, %p_shl4_cast
  %p_shl6 = call i19 @_ssdm_op_BitConcatenate.i19.i8.i11(i8 %window_b_V_1_2_loc_1, i11 0)
  %p_shl6_cast = zext i19 %p_shl6 to i20
  %p_shl7 = call i17 @_ssdm_op_BitConcatenate.i17.i8.i9(i8 %window_b_V_1_2_loc_1, i9 0)
  %p_shl7_cast = zext i17 %p_shl7 to i20
  %p_Val2_7_1_1 = sub i20 %p_shl7_cast, %p_shl6_cast
  %p_Val2_1_1_2 = call i16 @_ssdm_op_BitConcatenate.i16.i8.i8(i8 %window_r_V_1_2_loc_2, i8 0)
  %p_Val2_1_1_2_cast = zext i16 %p_Val2_1_1_2 to i20
  %p_Val2_4_1_2 = call i16 @_ssdm_op_BitConcatenate.i16.i8.i8(i8 %window_g_V_1_2_loc_2, i8 0)
  %p_Val2_4_1_2_cast = zext i16 %p_Val2_4_1_2 to i20
  %p_Val2_7_1_2 = call i16 @_ssdm_op_BitConcatenate.i16.i8.i8(i8 %window_b_V_1_2_loc_2, i8 0)
  %p_Val2_7_1_2_cast = zext i16 %p_Val2_7_1_2 to i20
  %p_Val2_1_2 = call i15 @_ssdm_op_BitConcatenate.i15.i8.i7(i8 %window_r_V_2_1_load, i7 0)
  %p_Val2_1_2_cast = zext i15 %p_Val2_1_2 to i17
  %p_Val2_4_2 = call i15 @_ssdm_op_BitConcatenate.i15.i8.i7(i8 %window_g_V_2_1_load, i7 0)
  %p_Val2_4_2_cast = zext i15 %p_Val2_4_2 to i17
  %p_Val2_7_2 = call i15 @_ssdm_op_BitConcatenate.i15.i8.i7(i8 %window_b_V_2_1_load, i7 0)
  %p_Val2_7_2_cast = zext i15 %p_Val2_7_2 to i17
  %p_Val2_1_2_1 = call i16 @_ssdm_op_BitConcatenate.i16.i8.i8(i8 %window_r_V_2_2_loc_1, i8 0)
  %p_Val2_1_2_1_cast = zext i16 %p_Val2_1_2_1 to i17
  %p_Val2_4_2_1 = call i16 @_ssdm_op_BitConcatenate.i16.i8.i8(i8 %window_g_V_2_2_loc_1, i8 0)
  %p_Val2_4_2_1_cast = zext i16 %p_Val2_4_2_1 to i17
  %p_Val2_7_2_1 = call i16 @_ssdm_op_BitConcatenate.i16.i8.i8(i8 %window_b_V_2_2_loc_1, i8 0)
  %p_Val2_7_2_1_cast = zext i16 %p_Val2_7_2_1 to i17
  %p_Val2_1_2_2 = call i15 @_ssdm_op_BitConcatenate.i15.i8.i7(i8 %window_r_V_2_2_loc_2, i7 0)
  %p_Val2_1_2_2_cast = zext i15 %p_Val2_1_2_2 to i18
  %tmp1 = add i17 %p_Val2_1_2_cast, %p_Val2_1_2_1_cast
  %tmp23_cast = zext i17 %tmp1 to i20
  %tmp2 = add i20 %p_Val2_1_0_1_cast, %p_Val2_1_1_1
  %tmp3 = add i20 %p_Val2_1_1_2_cast, %tmp2
  %tmp4 = add i20 %tmp23_cast, %tmp3
  %tmp22_cast = sext i20 %tmp4 to i21
  %tmp5 = add i17 %p_Val2_1_1_cast, %p_Val2_11_cast
  %tmp27_cast = zext i17 %tmp5 to i19
  %tmp6 = add i18 130048, %p_Val2_1_2_2_cast
  %tmp7 = add i18 %p_Val2_1_0_2_cast, %tmp6
  %tmp28_cast = zext i18 %tmp7 to i19
  %tmp8 = add i19 %tmp27_cast, %tmp28_cast
  %tmp26_cast = zext i19 %tmp8 to i21
  %tmp_s = zext i19 %tmp8 to i20
  %p_Val2_2_2_2 = add i21 %tmp22_cast, %tmp26_cast
  %p_Val2_2_2_2_cast = add i20 %tmp_s, %tmp4
  %p_Val2_4_2_2 = call i15 @_ssdm_op_BitConcatenate.i15.i8.i7(i8 %window_g_V_2_2_loc_2, i7 0)
  %p_Val2_4_2_2_cast = zext i15 %p_Val2_4_2_2 to i18
  %tmp = add i17 %p_Val2_4_2_cast, %p_Val2_4_2_1_cast
  %tmp31_cast = zext i17 %tmp to i20
  %tmp9 = add i20 %p_Val2_4_0_1_cast, %p_Val2_4_1_1
  %tmp10 = add i20 %p_Val2_4_1_2_cast, %tmp9
  %tmp11 = add i20 %tmp31_cast, %tmp10
  %tmp30_cast = sext i20 %tmp11 to i21
  %tmp12 = add i17 %p_Val2_4_1_cast, %p_Val2_4_cast
  %tmp35_cast = zext i17 %tmp12 to i19
  %tmp13 = add i18 130048, %p_Val2_4_2_2_cast
  %tmp14 = add i18 %p_Val2_4_0_2_cast, %tmp13
  %tmp36_cast = zext i18 %tmp14 to i19
  %tmp15 = add i19 %tmp35_cast, %tmp36_cast
  %tmp34_cast = zext i19 %tmp15 to i21
  %tmp_6 = zext i19 %tmp15 to i20
  %p_Val2_5_2_2 = add i21 %tmp30_cast, %tmp34_cast
  %p_Val2_5_2_2_cast = add i20 %tmp_6, %tmp11
  %p_Val2_7_2_2 = call i15 @_ssdm_op_BitConcatenate.i15.i8.i7(i8 %window_b_V_2_2_loc_2, i7 0)
  %p_Val2_7_2_2_cast = zext i15 %p_Val2_7_2_2 to i18
  %tmp16 = add i17 %p_Val2_7_2_cast, %p_Val2_7_2_1_cast
  %tmp39_cast = zext i17 %tmp16 to i20
  %tmp17 = add i20 %p_Val2_7_0_1_cast, %p_Val2_7_1_1
  %tmp18 = add i20 %p_Val2_7_1_2_cast, %tmp17
  %tmp19 = add i20 %tmp39_cast, %tmp18
  %tmp38_cast = sext i20 %tmp19 to i21
  %tmp20 = add i17 %p_Val2_7_1_cast, %p_Val2_7_cast
  %tmp43_cast = zext i17 %tmp20 to i19
  %tmp21 = add i18 130048, %p_Val2_7_2_2_cast
  %tmp22 = add i18 %p_Val2_7_0_2_cast, %tmp21
  %tmp44_cast = zext i18 %tmp22 to i19
  %tmp23 = add i19 %tmp43_cast, %tmp44_cast
  %tmp42_cast = zext i19 %tmp23 to i21
  %tmp_10 = zext i19 %tmp23 to i20
  %p_Val2_8_2_2 = add i21 %tmp38_cast, %tmp42_cast
  %p_Val2_8_2_2_cast = add i20 %tmp_10, %tmp19
  %tmp_27 = call i1 @_ssdm_op_BitSelect.i1.i21.i32(i21 %p_Val2_2_2_2, i32 20)
  %tmp_11 = icmp sgt i21 %p_Val2_2_2_2, 261120
  %p_sum_r_cast = select i1 %tmp_27, i20 0, i20 261120
  %tmp_12 = or i1 %tmp_27, %tmp_11
  %p_Val2_s_6 = select i1 %tmp_12, i20 %p_sum_r_cast, i20 %p_Val2_2_2_2_cast
  %tmp_29 = call i1 @_ssdm_op_BitSelect.i1.i21.i32(i21 %p_Val2_5_2_2, i32 20)
  %tmp_13 = icmp sgt i21 %p_Val2_5_2_2, 261120
  %p_sum_g_cast = select i1 %tmp_29, i20 0, i20 261120
  %tmp_14 = or i1 %tmp_29, %tmp_13
  %p_Val2_2 = select i1 %tmp_14, i20 %p_sum_g_cast, i20 %p_Val2_5_2_2_cast
  %tmp_31 = call i1 @_ssdm_op_BitSelect.i1.i21.i32(i21 %p_Val2_8_2_2, i32 20)
  %tmp_15 = icmp sgt i21 %p_Val2_8_2_2, 261120
  %p_sum_b_cast = select i1 %tmp_31, i20 0, i20 261120
  %tmp_19 = or i1 %tmp_31, %tmp_15
  %p_Val2_1 = select i1 %tmp_19, i20 %p_sum_b_cast, i20 %p_Val2_8_2_2_cast
  %ret_V_cast = call i8 @_ssdm_op_PartSelect.i8.i20.i32.i32(i20 %p_Val2_s_6, i32 10, i32 17)
  %tmp_33 = call i1 @_ssdm_op_BitSelect.i1.i20.i32(i20 %p_Val2_s_6, i32 19)
  %tmp_35 = trunc i20 %p_Val2_s_6 to i10
  %tmp_16 = icmp eq i10 %tmp_35, 0
  %ret_V_1 = add i8 1, %ret_V_cast
  %tmp_20 = call i8 @_ssdm_op_PartSelect.i8.i20.i32.i32(i20 %p_Val2_s_6, i32 10, i32 17)
  %tmp_21 = select i1 %tmp_16, i8 %tmp_20, i8 %ret_V_1
  %tmp_22 = select i1 %tmp_33, i8 %tmp_21, i8 %tmp_20
  %ret_V_2_cast = call i8 @_ssdm_op_PartSelect.i8.i20.i32.i32(i20 %p_Val2_2, i32 10, i32 17)
  %tmp_37 = call i1 @_ssdm_op_BitSelect.i1.i20.i32(i20 %p_Val2_2, i32 19)
  %tmp_39 = trunc i20 %p_Val2_2 to i10
  %tmp_17 = icmp eq i10 %tmp_39, 0
  %ret_V_3 = add i8 1, %ret_V_2_cast
  %tmp_23 = call i8 @_ssdm_op_PartSelect.i8.i20.i32.i32(i20 %p_Val2_2, i32 10, i32 17)
  %tmp_24 = select i1 %tmp_17, i8 %tmp_23, i8 %ret_V_3
  %tmp_25 = select i1 %tmp_37, i8 %tmp_24, i8 %tmp_23
  %ret_V_4_cast = call i8 @_ssdm_op_PartSelect.i8.i20.i32.i32(i20 %p_Val2_1, i32 10, i32 17)
  %tmp_41 = call i1 @_ssdm_op_BitSelect.i1.i20.i32(i20 %p_Val2_1, i32 19)
  %tmp_43 = trunc i20 %p_Val2_1 to i10
  %tmp_18 = icmp eq i10 %tmp_43, 0
  %ret_V_5 = add i8 1, %ret_V_4_cast
  %tmp_26 = call i8 @_ssdm_op_PartSelect.i8.i20.i32.i32(i20 %p_Val2_1, i32 10, i32 17)
  %tmp_28 = select i1 %tmp_18, i8 %tmp_26, i8 %ret_V_5
  %tmp_30 = select i1 %tmp_41, i8 %tmp_28, i8 %tmp_26
  %data_out_b_V_addr = call i24 @_ssdm_op_BitConcatenate.i24.i8.i8.i8(i8 %tmp_30, i8 %tmp_25, i8 %tmp_22)
  call void @_ssdm_op_Write.axis.i24P(i24* %data_out, i24 %data_out_b_V_addr)
  br label %._crit_edge51

._crit_edge51:                                    ; preds = %.preheader.preheader.i.0_ifconv, %3
  %empty = call i32 (...)* @_ssdm_op_SpecRegionEnd([7 x i8]* @p_str6, i32 %tmp_4)
  %x_1 = add i11 %x_mid2, 1
  br label %0

.reset:                                           ; preds = %0
  call void (...)* @_ssdm_op_SpecLoopName([14 x i8]* @y_loop_x_loop_str)
  %empty_7 = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 2076601, i64 2076601, i64 2076601)
  %exitcond = icmp eq i11 %x, -127
  %x_mid2 = select i1 %exitcond, i11 0, i11 %x
  %y_s = add i11 %y, 1
  %tmp_1_mid1 = icmp ult i11 %y_s, -968
  %tmp_1_mid2 = select i1 %exitcond, i1 %tmp_1_mid1, i1 %tmp_1
  %tmp_3_mid1 = icmp ne i11 %y_s, 0
  %tmp_3_mid2 = select i1 %exitcond, i1 %tmp_3_mid1, i1 %tmp_3
  %y_mid2 = select i1 %exitcond, i11 %y_s, i11 %y
  call void (...)* @_ssdm_op_SpecLoopName([7 x i8]* @p_str6) nounwind
  %tmp_4 = call i32 (...)* @_ssdm_op_SpecRegionBegin([7 x i8]* @p_str6)
  call void (...)* @_ssdm_op_SpecPipeline(i32 1, i32 1, i32 1, i32 0, [1 x i8]* @p_str) nounwind
  %window_r_V_0_1_load = load i8* @window_r_V_0_1, align 1
  %window_g_V_0_1_load = load i8* @window_g_V_0_1, align 1
  %window_b_V_0_1_load = load i8* @window_b_V_0_1, align 1
  store i8 %window_r_V_0_2_loc_1, i8* @window_r_V_0_1, align 1
  store i8 %window_g_V_0_2_loc_1, i8* @window_g_V_0_1, align 1
  store i8 %window_b_V_0_2_loc_1, i8* @window_b_V_0_1, align 1
  %window_r_V_1_1_load = load i8* @window_r_V_1_1, align 1
  %window_g_V_1_1_load = load i8* @window_g_V_1_1, align 1
  %window_b_V_1_1_load = load i8* @window_b_V_1_1, align 1
  store i8 %window_r_V_1_2_loc_1, i8* @window_r_V_1_1, align 1
  store i8 %window_g_V_1_2_loc_1, i8* @window_g_V_1_1, align 1
  store i8 %window_b_V_1_2_loc_1, i8* @window_b_V_1_1, align 1
  %window_r_V_2_1_load = load i8* @window_r_V_2_1, align 1
  %window_g_V_2_1_load = load i8* @window_g_V_2_1, align 1
  %window_b_V_2_1_load = load i8* @window_b_V_2_1, align 1
  store i8 %window_r_V_2_2_loc_1, i8* @window_r_V_2_1, align 1
  store i8 %window_g_V_2_2_loc_1, i8* @window_g_V_2_1, align 1
  store i8 %window_b_V_2_2_loc_1, i8* @window_b_V_2_1, align 1
  %tmp_5 = icmp ult i11 %x_mid2, -128
  br i1 %tmp_5, label %.preheader38.preheader, label %.preheader.0

; <label>:4                                       ; preds = %0
  ret void
}

define weak void @_ssdm_op_Write.axis.i24P(i24*, i24) {
entry:
  store i24 %1, i24* %0
  ret void
}

define weak void @_ssdm_op_SpecTopModule(...) {
entry:
  ret void
}

define weak i32 @_ssdm_op_SpecRegionEnd(...) {
entry:
  ret i32 0
}

define weak i32 @_ssdm_op_SpecRegionBegin(...) {
entry:
  ret i32 0
}

define weak void @_ssdm_op_SpecPipeline(...) nounwind {
entry:
  ret void
}

define weak i32 @_ssdm_op_SpecLoopTripCount(...) {
entry:
  ret i32 0
}

define weak void @_ssdm_op_SpecLoopName(...) nounwind {
entry:
  ret void
}

define weak void @_ssdm_op_SpecInterface(...) nounwind {
entry:
  ret void
}

define weak void @_ssdm_op_SpecBitsMap(...) {
entry:
  ret void
}

define weak i24 @_ssdm_op_Read.axis.volatile.i24P(i24*) {
entry:
  %empty = load i24* %0
  ret i24 %empty
}

define weak i8 @_ssdm_op_PartSelect.i8.i24.i32.i32(i24, i32, i32) nounwind readnone {
entry:
  %empty = call i24 @llvm.part.select.i24(i24 %0, i32 %1, i32 %2)
  %empty_8 = trunc i24 %empty to i8
  ret i8 %empty_8
}

define weak i8 @_ssdm_op_PartSelect.i8.i20.i32.i32(i20, i32, i32) nounwind readnone {
entry:
  %empty = call i20 @llvm.part.select.i20(i20 %0, i32 %1, i32 %2)
  %empty_9 = trunc i20 %empty to i8
  ret i8 %empty_9
}

define weak i10 @_ssdm_op_PartSelect.i10.i20.i32.i32(i20, i32, i32) nounwind readnone {
entry:
  %empty = call i20 @llvm.part.select.i20(i20 %0, i32 %1, i32 %2)
  %empty_10 = trunc i20 %empty to i10
  ret i10 %empty_10
}

define weak i1 @_ssdm_op_BitSelect.i1.i21.i32(i21, i32) nounwind readnone {
entry:
  %empty = trunc i32 %1 to i21
  %empty_11 = shl i21 1, %empty
  %empty_12 = and i21 %0, %empty_11
  %empty_13 = icmp ne i21 %empty_12, 0
  ret i1 %empty_13
}

define weak i1 @_ssdm_op_BitSelect.i1.i20.i32(i20, i32) nounwind readnone {
entry:
  %empty = trunc i32 %1 to i20
  %empty_14 = shl i20 1, %empty
  %empty_15 = and i20 %0, %empty_14
  %empty_16 = icmp ne i20 %empty_15, 0
  ret i1 %empty_16
}

define weak i24 @_ssdm_op_BitConcatenate.i24.i8.i8.i8(i8, i8, i8) nounwind readnone {
entry:
  %empty = zext i8 %1 to i16
  %empty_17 = zext i8 %2 to i16
  %empty_18 = shl i16 %empty, 8
  %empty_19 = or i16 %empty_18, %empty_17
  %empty_20 = zext i8 %0 to i24
  %empty_21 = zext i16 %empty_19 to i24
  %empty_22 = shl i24 %empty_20, 16
  %empty_23 = or i24 %empty_22, %empty_21
  ret i24 %empty_23
}

define weak i19 @_ssdm_op_BitConcatenate.i19.i8.i11(i8, i11) nounwind readnone {
entry:
  %empty = zext i8 %0 to i19
  %empty_24 = zext i11 %1 to i19
  %empty_25 = shl i19 %empty, 11
  %empty_26 = or i19 %empty_25, %empty_24
  ret i19 %empty_26
}

define weak i17 @_ssdm_op_BitConcatenate.i17.i8.i9(i8, i9) nounwind readnone {
entry:
  %empty = zext i8 %0 to i17
  %empty_27 = zext i9 %1 to i17
  %empty_28 = shl i17 %empty, 9
  %empty_29 = or i17 %empty_28, %empty_27
  ret i17 %empty_29
}

define weak i16 @_ssdm_op_BitConcatenate.i16.i8.i8(i8, i8) nounwind readnone {
entry:
  %empty = zext i8 %0 to i16
  %empty_30 = zext i8 %1 to i16
  %empty_31 = shl i16 %empty, 8
  %empty_32 = or i16 %empty_31, %empty_30
  ret i16 %empty_32
}

define weak i15 @_ssdm_op_BitConcatenate.i15.i8.i7(i8, i7) nounwind readnone {
entry:
  %empty = zext i8 %0 to i15
  %empty_33 = zext i7 %1 to i15
  %empty_34 = shl i15 %empty, 7
  %empty_35 = or i15 %empty_34, %empty_33
  ret i15 %empty_35
}

declare void @_GLOBAL__I_a() nounwind section ".text.startup"

!opencl.kernels = !{!0, !7, !13, !13, !17, !17, !23, !23, !26, !28, !31, !31, !17, !32, !35, !40, !40, !17, !42, !44, !44, !17, !23, !35, !42, !45, !45, !47, !47, !17, !26, !26, !17, !17, !48, !48, !17, !26, !50, !53, !17, !17, !17, !17, !17, !17, !17, !17, !54, !54, !56, !17, !17, !58, !58, !61, !17, !31, !31, !17, !63, !17, !17, !17, !66, !66, !68, !68, !70, !17, !17, !17, !72, !31, !31, !74, !17, !17, !17, !76, !76, !78, !78, !80, !17, !17, !17, !17, !17, !17, !82, !17, !17, !17, !84, !84, !85, !44, !44, !17, !17, !87, !17, !17, !17, !17}
!hls.encrypted.func = !{}
!llvm.map.gv = !{!90}

!0 = metadata !{null, metadata !1, metadata !2, metadata !3, metadata !4, metadata !5, metadata !6}
!1 = metadata !{metadata !"kernel_arg_addr_space", i32 1}
!2 = metadata !{metadata !"kernel_arg_access_qual", metadata !"none"}
!3 = metadata !{metadata !"kernel_arg_type", metadata !"pixel_t [3]*"}
!4 = metadata !{metadata !"kernel_arg_type_qual", metadata !""}
!5 = metadata !{metadata !"kernel_arg_name", metadata !"window"}
!6 = metadata !{metadata !"reqd_work_group_size", i32 1, i32 1, i32 1}
!7 = metadata !{null, metadata !8, metadata !9, metadata !10, metadata !11, metadata !12, metadata !6}
!8 = metadata !{metadata !"kernel_arg_addr_space", i32 1, i32 1}
!9 = metadata !{metadata !"kernel_arg_access_qual", metadata !"none", metadata !"none"}
!10 = metadata !{metadata !"kernel_arg_type", metadata !"pixel_t*", metadata !"pixel_t*"}
!11 = metadata !{metadata !"kernel_arg_type_qual", metadata !"const", metadata !""}
!12 = metadata !{metadata !"kernel_arg_name", metadata !"data_in", metadata !"data_out"}
!13 = metadata !{null, metadata !14, metadata !2, metadata !15, metadata !4, metadata !16, metadata !6}
!14 = metadata !{metadata !"kernel_arg_addr_space", i32 0}
!15 = metadata !{metadata !"kernel_arg_type", metadata !"int"}
!16 = metadata !{metadata !"kernel_arg_name", metadata !"val"}
!17 = metadata !{null, metadata !18, metadata !19, metadata !20, metadata !21, metadata !22, metadata !6}
!18 = metadata !{metadata !"kernel_arg_addr_space"}
!19 = metadata !{metadata !"kernel_arg_access_qual"}
!20 = metadata !{metadata !"kernel_arg_type"}
!21 = metadata !{metadata !"kernel_arg_type_qual"}
!22 = metadata !{metadata !"kernel_arg_name"}
!23 = metadata !{null, metadata !14, metadata !2, metadata !24, metadata !4, metadata !25, metadata !6}
!24 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed<28, 18, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!25 = metadata !{metadata !"kernel_arg_name", metadata !"op"}
!26 = metadata !{null, metadata !14, metadata !2, metadata !27, metadata !4, metadata !25, metadata !6}
!27 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<28, 18, true, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!28 = metadata !{null, metadata !14, metadata !2, metadata !29, metadata !4, metadata !30, metadata !6}
!29 = metadata !{metadata !"kernel_arg_type", metadata !"_Bool"}
!30 = metadata !{metadata !"kernel_arg_name", metadata !"Cnative"}
!31 = metadata !{null, metadata !14, metadata !2, metadata !15, metadata !4, metadata !25, metadata !6}
!32 = metadata !{null, metadata !14, metadata !2, metadata !33, metadata !4, metadata !34, metadata !6}
!33 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_uint<8> &"}
!34 = metadata !{metadata !"kernel_arg_name", metadata !"op2"}
!35 = metadata !{null, metadata !36, metadata !9, metadata !37, metadata !38, metadata !39, metadata !6}
!36 = metadata !{metadata !"kernel_arg_addr_space", i32 0, i32 0}
!37 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<28, 18, true, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &", metadata !"int"}
!38 = metadata !{metadata !"kernel_arg_type_qual", metadata !"", metadata !""}
!39 = metadata !{metadata !"kernel_arg_name", metadata !"op", metadata !"i_op"}
!40 = metadata !{null, metadata !14, metadata !2, metadata !15, metadata !4, metadata !41, metadata !6}
!41 = metadata !{metadata !"kernel_arg_name", metadata !"i_op"}
!42 = metadata !{null, metadata !14, metadata !2, metadata !43, metadata !4, metadata !34, metadata !6}
!43 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<32, 32, true, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!44 = metadata !{null, metadata !14, metadata !2, metadata !43, metadata !4, metadata !25, metadata !6}
!45 = metadata !{null, metadata !14, metadata !2, metadata !46, metadata !4, metadata !34, metadata !6}
!46 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<36, 26, true, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!47 = metadata !{null, metadata !14, metadata !2, metadata !46, metadata !4, metadata !25, metadata !6}
!48 = metadata !{null, metadata !14, metadata !2, metadata !49, metadata !4, metadata !25, metadata !6}
!49 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<37, 27, true, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!50 = metadata !{null, metadata !36, metadata !9, metadata !51, metadata !38, metadata !52, metadata !6}
!51 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<8, false> &", metadata !"const ap_fixed_base<28, 18, true, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!52 = metadata !{metadata !"kernel_arg_name", metadata !"i_op", metadata !"op"}
!53 = metadata !{null, metadata !14, metadata !2, metadata !27, metadata !4, metadata !34, metadata !6}
!54 = metadata !{null, metadata !14, metadata !2, metadata !55, metadata !4, metadata !25, metadata !6}
!55 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<8, false> &"}
!56 = metadata !{null, metadata !14, metadata !2, metadata !57, metadata !4, metadata !25, metadata !6}
!57 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<8, 8, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!58 = metadata !{null, metadata !14, metadata !2, metadata !59, metadata !4, metadata !60, metadata !6}
!59 = metadata !{metadata !"kernel_arg_type", metadata !"double"}
!60 = metadata !{metadata !"kernel_arg_name", metadata !"v"}
!61 = metadata !{null, metadata !14, metadata !2, metadata !59, metadata !4, metadata !62, metadata !6}
!62 = metadata !{metadata !"kernel_arg_name", metadata !"d"}
!63 = metadata !{null, metadata !36, metadata !9, metadata !64, metadata !38, metadata !65, metadata !6}
!64 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<1, false> &", metadata !"const ap_int_base<54, true> &"}
!65 = metadata !{metadata !"kernel_arg_name", metadata !"op", metadata !"op2"}
!66 = metadata !{null, metadata !14, metadata !2, metadata !67, metadata !4, metadata !25, metadata !6}
!67 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<54, true> &"}
!68 = metadata !{null, metadata !14, metadata !2, metadata !69, metadata !4, metadata !25, metadata !6}
!69 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<1, false> &"}
!70 = metadata !{null, metadata !14, metadata !2, metadata !71, metadata !4, metadata !34, metadata !6}
!71 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<55, true> &"}
!72 = metadata !{null, metadata !36, metadata !9, metadata !73, metadata !38, metadata !39, metadata !6}
!73 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<11, false> &", metadata !"int"}
!74 = metadata !{null, metadata !36, metadata !9, metadata !75, metadata !38, metadata !65, metadata !6}
!75 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<11, false> &", metadata !"const ap_int_base<32, true> &"}
!76 = metadata !{null, metadata !14, metadata !2, metadata !77, metadata !4, metadata !25, metadata !6}
!77 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<32, true> &"}
!78 = metadata !{null, metadata !14, metadata !2, metadata !79, metadata !4, metadata !25, metadata !6}
!79 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<11, false> &"}
!80 = metadata !{null, metadata !14, metadata !2, metadata !81, metadata !4, metadata !34, metadata !6}
!81 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<33, true> &"}
!82 = metadata !{null, metadata !14, metadata !2, metadata !59, metadata !4, metadata !83, metadata !6}
!83 = metadata !{metadata !"kernel_arg_name", metadata !"pf"}
!84 = metadata !{null, metadata !14, metadata !2, metadata !15, metadata !4, metadata !60, metadata !6}
!85 = metadata !{null, metadata !14, metadata !2, metadata !15, metadata !4, metadata !86, metadata !6}
!86 = metadata !{metadata !"kernel_arg_name", metadata !"b"}
!87 = metadata !{null, metadata !14, metadata !2, metadata !88, metadata !4, metadata !89, metadata !6}
!88 = metadata !{metadata !"kernel_arg_type", metadata !"const pixel_t &"}
!89 = metadata !{metadata !"kernel_arg_name", metadata !""}
!90 = metadata !{metadata !91, [1 x i32]* @llvm_global_ctors_0}
!91 = metadata !{metadata !92}
!92 = metadata !{i32 0, i32 31, metadata !93}
!93 = metadata !{metadata !94}
!94 = metadata !{metadata !"llvm.global_ctors.0", metadata !95, metadata !"", i32 0, i32 31}
!95 = metadata !{metadata !96}
!96 = metadata !{i32 0, i32 0, i32 1}
!97 = metadata !{metadata !98, metadata !101, metadata !104}
!98 = metadata !{i32 0, i32 7, metadata !99}
!99 = metadata !{metadata !100}
!100 = metadata !{metadata !"data_out.r.V", metadata !95, metadata !"uint8", i32 0, i32 7}
!101 = metadata !{i32 8, i32 15, metadata !102}
!102 = metadata !{metadata !103}
!103 = metadata !{metadata !"data_out.g.V", metadata !95, metadata !"uint8", i32 0, i32 7}
!104 = metadata !{i32 16, i32 23, metadata !105}
!105 = metadata !{metadata !106}
!106 = metadata !{metadata !"data_out.b.V", metadata !95, metadata !"uint8", i32 0, i32 7}
!107 = metadata !{metadata !108, metadata !111, metadata !114}
!108 = metadata !{i32 0, i32 7, metadata !109}
!109 = metadata !{metadata !110}
!110 = metadata !{metadata !"data_in.r.V", metadata !95, metadata !"uint8", i32 0, i32 7}
!111 = metadata !{i32 8, i32 15, metadata !112}
!112 = metadata !{metadata !113}
!113 = metadata !{metadata !"data_in.g.V", metadata !95, metadata !"uint8", i32 0, i32 7}
!114 = metadata !{i32 16, i32 23, metadata !115}
!115 = metadata !{metadata !116}
!116 = metadata !{metadata !"data_in.b.V", metadata !95, metadata !"uint8", i32 0, i32 7}
