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
			Git.clone ReferenceRepo.url <> ".git"
			assert Git.commits == ReferenceRepo.expected_commits
			assert Git.url == ReferenceRepo.url
		end
	end

	test "clone a github project, checkout a commit and verify a message" do
		with_tmp_folder do
			Git.clone ReferenceRepo.url <> ".git"
			Git.checkout ReferenceRepo.second_commit_id
			assert Git.current_commit == ReferenceRepo.second_commit_id
			assert ReferenceRepo.second_version_of_readme?()
			assert Git.commit_message(ReferenceRepo.forth_commit_id)== 
				ReferenceRepo.forth_commit_message
				
		end
	end
end