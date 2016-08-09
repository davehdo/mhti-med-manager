json.array!(@medications) do |medication|
	json.partial! medication
end

