require 'git'
require 'graphviz'


def create_graph(git, filename)
  g = GraphViz.new( :G, :type => :digraph )
  
  git.log.each do |commit|
    child = g.add_nodes(commit.sha)
    commit.parents.each do |parent|
      parent_node = g.add_nodes(parent.sha)

      g.add_edges(parent_node, child)
    end
  end
  
  g.output( :png => filename )
end

def open_git(directory)
  git = Git.open(directory)
  return git
end

if ARGV.length != 2 then
  puts "Usage: ruby commit-graph.rb <repository> <output.png>"
  exit 1
end

git = open_git(ARGV[0])
create_graph(git, ARGV[1])
