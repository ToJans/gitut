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

defmodule ReferenceRepo do
	
	def url, do: "https://github.com/ToJans/testfixture-repo"

	def expected_commits do 
        [{"3ce6eec", "Initial commit"}, 
         {"90e0504", "Update the README with the correct reference to the gitut project"}, 
         {"8092953", "[skip] Let's try to skip an entry"}, 
         {"afcc832", "Do some more fine-tuning to the readme"}]	
    end
    def first_commit_id, 	do: expected_commits |> Enum.at(0) |> elem(0)
    def second_commit_id, 	do: expected_commits |> Enum.at(1) |> elem(0)
    def third_commit_id, 	do: expected_commits |> Enum.at(2) |> elem(0)
    def forth_commit_id, 	do: expected_commits |> Enum.at(3) |> elem(0)

    def second_version_of_readme? do
    	"README.md"
    		|> File.read!()
    	  	|> String.contains?("(http://github.com/ToJans/gitut)")
    end

    def forth_commit_message do
    	"Do some more fine-tuning to the readme\n\nIt does not mather what exactly in this case"
    end

    def gitut_commits do
    	expected_commits |> List.delete(2)
    end

end

defmodule Run do
	def gitut(cmd) do
		System.cmd('../bin/gitut #{cmd}')
	end
end

