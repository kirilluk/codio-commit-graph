require 'git'
require 'graphviz'

def create_graph(git, filename)
  # Create a new graph object
  g = GraphViz.new( :G, :type => :digraph )
  
  # For each commit, add a nodes and edges
  git.log.each do |commit|
    child = g.add_nodes(commit.sha[0..6], :style => "filled", :fillcolor => :lightblue)
    commit.parents.each do |parent|
      parent_node = g.add_nodes(parent.sha[0..6], :style => "filled", :fillcolor => :lightblue)

      # Add edge from this parent to current node
      g.add_edges(child, parent_node, :dir => "back")
    end
  end
  
  # Generate output image
  g.output( :png => filename )
end

def open_git(directory)
  git = Git.open(directory)
  return git
end

# Check commandline parameters
if ARGV.length != 2 then
  puts "Usage: ruby commit-graph.rb <repository> <output.png>"
  exit 1
end

# TODO
# Use the open_git and create_graph methods to create a commit log
# ARGV[0] is the Git directory
# ARGV[1] is the filename of the output image
