ExUnit.start

defmodule PathHelpers do
	defmacro with_tmp_folder([do: block]) do
		quote do
			old_path = Path.absname(".")
			name = PathHelpers.random_name
			path = Path.join(System.tmp_dir!,name)
				|> Path.absname
			File.rm_rf path
			File.mkdir path
			File.cd! path
			unquote(block)
			File.rm_rf! Path.join(path,"*.*")
			File.cd! old_path
			File.rmdir path # TODO: this fails
		end
	end

	def random_name do
		bytes = :crypto.strong_rand_bytes(10)
		hex = lc <<b>> inbits bytes, do: integer_to_list(b,16)
		hex 
		  |> List.flatten() 
		  |> String.from_char_list!()
	end


end

