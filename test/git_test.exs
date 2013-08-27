Code.require_file "../test_helper.exs", __FILE__

defmodule GitTest do
	use ExUnit.Case
	import PathHelpers

	
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
			Git.clone ReferenceRepo.url
			assert Git.commits == ReferenceRepo.expected_commits
		end
	end

	test "clone a github project, checkout a commit and verify a message" do
		with_tmp_folder do
			Git.clone "https://github.com/ToJans/testfixture-repo.git"
			Git.checkout ReferenceRepo.second_commit_id
			assert Git.current_commit == ReferenceRepo.second_commit_id
			assert ReferenceRepo.second_version_of_readme?()
			assert Git.commit_message(ReferenceRepo.forth_commit_id)== 
				ReferenceRepo.forth_commit_message
				
		end
	end
end

defmodule ReferenceRepo do
	def url, do: "https://github.com/ToJans/testfixture-repo.git"
	def expected_commits do 
        [{"3ce6eec", "Initial commit"}, 
         {"90e0504", "Update the README with the correct reference to the gitut project"}, 
         {"8092953", "[skip] Let's try to skip an entry"}, 
         {"afcc832", "Do some more fine-tuning to the readme"}]	
    end
    def second_commit_id, do: "90e0504"
    def second_version_of_readme? do
    	"README.md"
    		|> File.read!()
    	  	|> String.contains?("(http://github.com/ToJans/gitut)")
    end
    def forth_commit_id, do: "afcc832"

    def forth_commit_message do
    	"Do some more fine-tuning to the readme\n\nIt does not mather what exactly in this case"
    end

end