return {
	Layout = function(unitTest)
		local data = {
			title = 1,
			description = "Alternative Test",
			base = "terrain",
			zoom = 10,
			minZoom = 5,
			maxZoom = 19,
			center = {lat = -23.179017, long = -45.889188}
		}

		local error_func = function()
			Layout()
		end
		unitTest:assertError(error_func, "Argument must be a table.")

		error_func = function()
			Layout(1)
		end
		unitTest:assertError(error_func, "Arguments must be named.")

		error_func = function()
			Layout{
				arg = "void",
				center = data.center
			}
		end
		unitTest:assertError(error_func, unnecessaryArgumentMsg("arg"))

		error_func = function()
			Layout(clone(data))
		end
		unitTest:assertError(error_func, incompatibleTypeMsg("title", "string", 1))

		data.title = "Testing Layout"
		data.description = 1
		error_func = function()
			Layout(clone(data))
		end
		unitTest:assertError(error_func, incompatibleTypeMsg("description", "string", 1))

		data.description = "Alternative Test"
		data.base = 1
		error_func = function()
			Layout(clone(data))
		end
		unitTest:assertError(error_func, incompatibleTypeMsg("base", "string", 1))

		data.base = "normal"
		error_func = function()
			Layout(clone(data))
		end
		unitTest:assertError(error_func, "Basemap 'normal' is not supported.")

		data.base = "hybrid"
		data.zoom = "1"
		error_func = function()
			Layout(clone(data))
		end
		unitTest:assertError(error_func, incompatibleTypeMsg("zoom", "number", "1"))

		data.zoom = -1
		error_func = function()
			Layout(clone(data))
		end
		unitTest:assertError(error_func, "Argument 'zoom' must be a number >= 0 and <= 20, got '-1'.")

		data.zoom = 21
		error_func = function()
			Layout(clone(data))
		end
		unitTest:assertError(error_func, "Argument 'zoom' must be a number >= 0 and <= 20, got '21'.")

		data.zoom = 13
		data.minZoom = "1"
		error_func = function()
			Layout(clone(data))
		end
		unitTest:assertError(error_func, incompatibleTypeMsg("minZoom", "number", "1"))

		data.minZoom = -1
		error_func = function()
			Layout(clone(data))
		end
		unitTest:assertError(error_func, "Argument 'minZoom' must be a number >= 0 and <= 20, got '-1'.")

		data.minZoom = 21
		error_func = function()
			Layout(clone(data))
		end
		unitTest:assertError(error_func, "Argument 'minZoom' must be a number >= 0 and <= 20, got '21'.")

		data.minZoom = 5
		data.maxZoom = 4
		error_func = function()
			Layout(clone(data))
		end
		unitTest:assertError(error_func, "Argument 'minZoom' should be less than 'maxZoom' (4).")

		data.maxZoom = "1"
		error_func = function()
			Layout(clone(data))
		end
		unitTest:assertError(error_func, incompatibleTypeMsg("maxZoom", "number", "1"))

		data.maxZoom = -1
		error_func = function()
			Layout(clone(data))
		end
		unitTest:assertError(error_func, "Argument 'maxZoom' must be a number >= 0 and <= 20, got '-1'.")

		data.maxZoom = 21
		error_func = function()
			Layout(clone(data))
		end
		unitTest:assertError(error_func, "Argument 'maxZoom' must be a number >= 0 and <= 20, got '21'.")

		data.maxZoom = 19
		data.center = {-23.179017, long = -45.889188}
		error_func = function()
			Layout(clone(data))
		end
		unitTest:assertError(error_func, mandatoryArgumentMsg("lat"))

		data.center = {lat = -23.179017, -45.889188}
		error_func = function()
			Layout(clone(data))
		end
		unitTest:assertError(error_func, mandatoryArgumentMsg("long"))

		data.center = {lat = -91, long = 91}
		error_func = function()
			Layout(clone(data))
		end
		unitTest:assertError(error_func, "Center 'lat' must be a number >= -90 and <= 90, got '-91'.")

		data.center = {lat = 91, long = 91}
		error_func = function()
			Layout(clone(data))
		end
		unitTest:assertError(error_func, "Center 'lat' must be a number >= -90 and <= 90, got '91'.")

		data.center = {lat = 90, long = -181}
		error_func = function()
			Layout(clone(data))
		end
		unitTest:assertError(error_func, "Center 'long' must be a number >= -180 and <= 180, got '-181'.")

		data.center = {lat = 90, long = 181}
		error_func = function()
			Layout(clone(data))
		end
		unitTest:assertError(error_func, "Center 'long' must be a number >= -180 and <= 180, got '181'.")
	end
}