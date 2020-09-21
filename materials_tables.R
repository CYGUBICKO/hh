load("generateLabels.rda")

save(file = "materials_tables.rda"
	, floor_labs
	, roof_labs
	, wall_labs
	, cook_labs
	, light_labs
	, rent_labs
)
