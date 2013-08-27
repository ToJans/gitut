defmodule Git do
	@moduledoc """
	Git utilities that work on the current folder
	"""

	@doc """
	Get a chronological list of {"commit id","commit titles"}
	"""
	def commits() do
		git_lines("log --oneline")
			|> Enum.map(&commit_line_to_commit_tuple/1)
			|> Enum.filter( { nil, nil} != &1 )
			|> Enum.reverse
	end

	@doc """
	Get the current commit id
	"""
	def current_commit() do
		output =  git_cmd("rev-parse HEAD") 
		%r/[\d,a-f]{7}/
			|> Regex.scan(output) 
			|> List.flatten
			|> Enum.first
	end

	@doc """
	Checkout a commit; it forces & cleans the folder
	"""
	def checkout(commit_id) do
		git_cmd("checkout #{commit_id} -f")
		git_cmd("clean -f")
	end

	@doc """
	Clone a git repository in the current folder without a checkout. 
	If a repository exists in this folder, it is overwritten.
	"""
	def clone(url) do
		File.rm_rf(".git")
		git_lines("clone #{url} --no-checkout .")
	end

	@doc """
	Gets the the title and full commit message of a commit, separated by a 
	newline.
	"""
	def commit_message(commit_id) do
		git_cmd("log #{commit_id} -1 --pretty=format:%B")
	end

	defp git_lines(cmd) do
		git_cmd(cmd) |> String.split(%r/[\r?\n]+/)
	end

	defp git_cmd(cmd) do
		cmd = "git #{cmd} 2>&1" |> String.to_char_list!
		:os.cmd(cmd) |> String.from_char_list!
	end

	defp commit_line_to_commit_tuple(line) do
		captures = %r/^(?<id>[\da-f]{7}) (?<msg>.*)$/g
			|> Regex.captures(line)
		{captures[:id],captures[:msg]}
	end
end