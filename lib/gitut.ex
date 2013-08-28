defmodule Gitut do
	def main() do
		cmd = get_argv(0)
		if (valid_cmd?(cmd)) do
			apply(Gitut,binary_to_atom(cmd),[])
		else
			IO.puts """
			Unknown command: #{get_argv(0)}"

			"""
			help 
		end
	end

	# returns nth argv that does not start with `-`
	defp get_argv(index) do
		System.argv
			|> Enum.filter(fn x->!String.starts_with?(x,"-") end)
			|> Enum.at(index)
	end

	defp valid_cmd?(nil), do: false
	defp valid_cmd?(cmd) do
		cmd = binary_to_atom(cmd)
		get_help |> Enum.any?(fn {c,_doc}->c == cmd end )
	end

	@doc """
	Start a new gitut from a github `username/project`.

	# Example

	This will create a new tutor in the `testfixture-repo` folder.
	It clones the repository from `https://github.com/ToJans/testfixture-repo`.

	     gitut start ToJans/testfixture-repo

	"""
	def start() do
		get_argv(1) |> start_project()
	end

	defp start_project(nil) do
		IO.puts """
		Error: You need to define a project.

		"""
		help_cmd("start")
	end

	defp start_project(project) do
		path = Path.basename(project)
		File.mkdir! path
		File.cd! path
		System.cmd "cd #{path}"
		Git.clone "https://github.com/#{project}.git"
		commits |> hd |> elem(0) |> Git.checkout 
		IO.puts "Your project has been started in the folder #{path}. Enjoy!"
	end

	@doc """
	Find out what you have to do next to complete this step.

	# Example

	     gitut todo

	This will output what to do next.
	"""
	def todo do
		IO.puts """
		This is your next todo:

		"""

		complete_monad(next_commit,Git.commit_message(next_commit)) |> IO.puts
	end

	defp complete_monad(nil,_block) do
	 	"""
	 	CONGRATULATIONS!!!!

	 	This project is complete; there are no further steps.
	 	"""
	end

	defp complete_monad(_val,block) do
		block
	end

	@doc """
	Checks out the code for the current step and tells you what to do for the next step.

	# Example

	     gitut done

	"""
	def done do
		IO.puts """
		Getting the code for this step from github.
		"""
		next = next_commit
		if (next != nil), do: Git.checkout(next)
		todo
	end



	@doc """
	Shows the difference between your code, and the example reference code

	# Example

	     gitut diff

	"""
	def diff do
		IO.puts """
		This is the difference between your code and the example code on github:
		"""
		complete_monad(next_commit,Git.diff("#{next_commit}")) |> IO.puts 
	end

	@doc """
	Fires up a browser on github, where you can comment on this particular step.

	This functionality allows you to engage in a discussion with the intial committer or others.

	# Example

	     gitut comment

	"""
	def comment do
		complete_monad(next_commit,System.cmd("start #{Git.url}/commit/#{next_commit}"))
	end

	@doc """
	Shows a list of commands or the help for a command.
	"""
	def help() do
		get_argv(1) |> help_cmd
	end

	defp help_cmd(nil) do
		IO.puts """
		These are the available commands for gitut.

		"""
		get_help |> Enum.each(&puts_cmd_help/1)

		IO.puts """

		You can also add a verbose flag `-v` to any command to enable git interaction output. 

		Type `gitut [command]` (`command` without the brackets) to run a commmand.
		For example, type `gitut help start` for more info about `start`.

		"""
	end

	defp help_cmd(cmd) do
		text = get_help 
			|> Keyword.get(binary_to_atom(cmd),"Unknown command; type `gitut help` for a list of available commands")
		IO.puts("Help for: #{cmd}\n\n#{text}")
	end

	defp get_help() do
		Gitut.__info__(:docs)
			|> Enum.map(fn {{name,_arity},_line,_type,_parameters,doc} -> {name,doc} end)
			|> Enum.filter(fn {_name,doc} -> !nil?(doc) end)
	end
	

	def next_commit() do
		current = Git.current_commit
		commits 
		  |> Enum.map(&(elem(&1,0)))
		  |> Enum.drop_while(&1 != current)
		  |> Enum.drop(1)
		  |> Enum.at(0)
	end

	defp commits() do
		Git.commits()
			|> Enum.filter(fn {_sha,msg}-> !String.starts_with?(msg,"[skip]") end)
	end

	defp puts_cmd_help({name,hlp}) do
		hlp = Regex.split(%r/\n/,hlp) |> hd()

		IO.puts  "#{name}\t#{hlp}"
	end

end
