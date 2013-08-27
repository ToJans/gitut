Code.require_file "../test_helper.exs", __FILE__

defmodule GitTest do
	use ExUnit.Case
	import PathHelpers

	def expected_commits do 
        [{"3ce6eec", "Initial commit"}, 
         {"90e0504", "Update the README with the correct reference to the gitut project"}, 
         {"8092953", "[skip] Let's try to skip an entry"}, 
         {"afcc832", "Do some more fine-tuning to the readme"}]	end
	
	test "current commit id from a non-git folder should return nil" do
		with_tmp_folder do 
			assert Git.current_commit == nil
		end
	end

	test "commits from a non-git folder should return an empty list" do
		with_tmp_folder do 
			assert Git.commits == []
		end
	end

	test "clone a github project and verify commits exist" do
		with_tmp_folder do
			Git.clone "https://github.com/ToJans/testfixture-repo.git"
			assert Git.commits == expected_commits
		end
	end

	test "clone a github project, checkout a commit and verify a message" do
		with_tmp_folder do
			Git.clone "https://github.com/ToJans/testfixture-repo.git"
			Git.checkout "90e0504"
			assert Git.current_commit == "90e0504"
			readme = File.read!("README.md")
			assert String.contains?(readme,"(http://github.com/ToJans/gitut)")
			assert Git.commit_message("afcc832")== 
				"Do some more fine-tuning to the readme\n\nIt does not mather what exactly in this case"
		end
	end

end