extraction_setup \
	 -gds_layer_map \
		"PO1 41 0" \
		"ME1 46 0" \
		"ME2 48 0" \
		"ME3 50 0" \
		"ME4 52 0" \
		"ME5 54 0" \
		"ME6 56 0" \
		"ME7 58 0" \
		"ME8 59 0" \
		"CONT 39 0" \
		"VI1 47 0" \
		"VI2 49 0" \
		"VI3 51 0" \
		"VI4 53 0" \
		"VI5 55 0" \
		"VI6 57 0" \
		"VI7 60 0" \
	 -technology_layer_map \
		"PO1 PLY_C" \
		"ME1 ME1_C" \
		"ME2 ME2_C" \
		"ME3 ME3_C" \
		"ME4 ME4_C" \
		"ME5 ME5_C" \
		"ME6 ME6_C" \
		"ME7 ME7_C" \
		"ME8 ME8_C" \
		"CONT PLYCONT" \
		"VI1 via1" \
		"VI2 via2" \
		"VI3 via3" \
		"VI4 via4" \
		"VI5 via5" \
		"VI6 via6" \
		"VI7 via7"

input_db -type def \
         -gds_file_list  \
            \
  /usr/pack/umc-65-kgf/umc/ll/uk65lscllmvbbl/b03/gds/uk65lscllmvbbl.gds \
  /usr/pack/umc-65-kgf/umc/ll/u065gioll25mvir/b04/gds/u065gioll25mvir_8m1t0f1u.gds \

