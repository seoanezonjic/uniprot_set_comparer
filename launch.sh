#! /usr/bin/env bash
queries=`pwd`/queries
if [ $1 == "q" ]; then
	mkdir -p queries
	wget -O queries/I 'https://www.uniprot.org/uniprot/?query=inflammat*&format=tab&force=true&columns=id,entry%20name,reviewed,existence,annotation%20score,protein%20names,genes,database(HGNC),database(STRING)&fil=reviewed:yes%20AND%20organism:%22Homo%20sapiens%20(Human)%20[9606]%22'
	wget -O queries/A 'https://www.uniprot.org/uniprot/?query=angiog*&format=tab&force=true&columns=id,entry%20name,reviewed,existence,annotation%20score,protein%20names,genes,database(HGNC),database(STRING)&fil=reviewed:yes%20AND%20organism:%22Homo%20sapiens%20(Human)%20[9606]%22'
	wget -O queries/M 'https://www.uniprot.org/uniprot/?query=metastas*&format=tab&force=true&columns=id,entry%20name,reviewed,existence,annotation%20score,protein%20names,genes,database(HGNC),database(STRING)&fil=reviewed:yes%20AND%20organism:%22Homo%20sapiens%20(Human)%20[9606]%22'
	mkdir filtered_queries
	cd queries
	for file in ./*; do grep 'Evidence at protein level' $file | grep '5 out of 5' > ../filtered_queries/$file ; done
	cd ..
fi


results=`pwd`/results
combinations=$results/combinations
if [ $1 == "a" ]; then
	. ~soft_bio_267/initializes/init_ruby
	export PATH=scripts:$PATH
	mkdir -p results/combinations
	get_venn_groups.rb -i 'filtered_queries/*' -o results/group_asignation -s '' -c results/combinations

fi

temp_path=`pwd`/temp
if [ $1 == "d" ]; then
	mkdir temp
	wget https://stringdb-static.org/download/protein.links.v11.5/9606.protein.links.v11.5.txt.gz -O $temp_path"/9606.protein.links.v11.5.txt.gz"
	gunzip $temp_path'/9606.protein.links.v11.5.txt.gz'
	mv $temp_path'/9606.protein.links.v11.5.txt' $temp_path'/string_data.txt' # copied from original execution
	
	wget https://stringdb-static.org/download/protein.info.v11.5/9606.protein.info.v11.5.txt.gz -O $temp_path"/9606.protein.info.v11.5.txt.gz"
	gunzip $temp_path"/9606.protein.info.v11.5.txt.gz"
fi

if [ $1 == "w" ]; then
	source ~soft_bio_267/initializes/init_autoflow
	string_thr=900
	var_info=`echo -e "\\$string_thr=$string_thr,
	\\$lists=$queries,
	\\$combs=$combinations,
	\\$top_clusters=10,
	\\$string_data=$temp_path/string_data.txt" | tr -d '[:space:]' `
	AutoFlow -w templates/workflow.txt -c 4 -t '7-00:00:00' -o $results"/wf_res" -n 'sr' -e -V $var_info $2
fi
