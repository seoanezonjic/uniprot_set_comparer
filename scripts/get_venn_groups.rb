#! /usr/bin/env ruby
require 'optparse'

###############################################################################
# METHODS
################################################################################
def add2hash(hash, key, val)
	query = hash[key]
	if query.nil?
		hash[key] = [val]
	else
		query << val
	end
end

#################################################################################################
## INPUT PARSING
#################################################################################################
options = {}

optparse = OptionParser.new do |opts|
        options[:files] = []
        opts.on( '-i', '--input_file FILES', 'Files from extract data. use "*" to specific several files that share the name' ) do |data|
            options[:files] = data.split(',')
        end

        options[:sep] = ","
        opts.on( '-s', '--separator STRING', 'String to be used in set separation' ) do |data|
            options[:sep] = data
        end

        options[:output] = 'group_table'
        opts.on( '-o', '--output_file FILES', 'Output file' ) do |data|
            options[:output] = data
        end

        options[:combination_path] = nil
        opts.on( '-c', '--combination_path PATH', 'Path to folder in which the combination lists are saved' ) do |data|
            options[:combination_path] = data
        end


        opts.banner = "Usage: #{File.basename(__FILE__)} \n\n"

        # This displays the help screen
        opts.on( '-h', '--help', 'Display this screen' ) do
                puts opts
                exit
        end

end # End opts

# parse options and remove from ARGV
optparse.parse!

data = {}
options[:files].each do |file|
	Dir.glob(file).each do |f|
		group_name = File.basename(f)
		File.open(f).each do |line|
			id = line.chomp.split("\t").first
			add2hash(data, id, group_name)
		end
	end
end

File.open(options[:output], 'w') do |f|
	data.each do |id, group|
		f.puts "#{id}\t#{group.join(options[:sep])}"
	end
end

if !options[:combination_path].nil?
	groups = {}
	data.each do |item_id, group_names|
		group_name = group_names.join(options[:sep])
		add2hash(groups, group_name, item_id)
	end
	group_names = groups.keys
	combinations = {}
	group_names.length.times do |n|
		group_names.combination(n+1) do |combination|
			items = []
			combination.each{|group| items = items | groups[group]}
			combinations[combination.join('-')] = items
		end
	end
	combinations.each do |comb, items|
		File.open(File.join(options[:combination_path], comb), 'w') do |f|
			f.print(items.join("\n"))
		end
	end
end

