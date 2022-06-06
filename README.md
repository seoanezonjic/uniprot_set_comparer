# uniprot_set_comparer

## File outline
* queries: Files with original data retrieved from Uniprot (human, reviewed and keyword)
* filtered_queries: From original queries, entries that have not contain the string "Evidence at protein level" are removed
* results
  * group_asignation: File with all the proteins retrieved from Uniprot tagged with a letter for each query that presents the protein
  * combinations: Permutations of the subsets that emerge when the queries are intersected (venn). One protein list per subset.
  * wf_res: Folder that contains analysis performed onto subsets
    * crank_0000: Analysis of subset coherence in interaction network. A random subset is added for each original subset
    * stat_test.R_0000: Plot of ranking distribution and t-stat for subset rankings (comparison of random vs original)
    * clusters_to_enrichment.R_0000: GO functional enrichment for the top 10 original subsets given by crank.
