# **Companion Website for "Constructing and Using Cell Type Populations of the Human Reference Atlas"**

Andreas Bueckle<sup>1</sup>\*, Bruce W. Herr II<sup>1</sup>\*, Lu Chen<sup>2</sup>, Daniel Bolin<sup>1</sup>, Danial Qaurooni<sup>1</sup>, Michael Ginda<sup>1</sup>, Yashcardhan Jain<sup>1</sup>, Aleix Puig Barbé <sup>3</sup>,Kristin Ardlie<sup>4</sup>, Fusheng Wang<sup>2</sup>, Katy Börner<sup>1</sup>\*

<sup>1</sup> Department of Intelligent Systems Engineering, Luddy School of Informatics, Computing, and Engineering, Indiana University, Bloomington, IN 47408, USA \
<sup>2</sup> Department of Computer Science and Department of Biomedical Informatics, Stony Brook University, Stony Brook, 11794, NY, USA \
<sup>3</sup> European Bioinformatics Institute (EMBL-EBI), Wellcome Genome Campus, Hinxton, Cambridge CB10 1SD, UK\
<sup>4</sup> Broad Institute, Cambridge, 02142, MA, USA \
\* Corresponding authors\
[abueckle@iu.edu](mailto:abueckle@iu.edu)\
[bherr@iu.edu](mailto:bherr@iu.edu)\
[katy@iu.edu](katy@iu.edu)
 
The Human Reference Atlas (HRA) represents major anatomical structures and their healthy cell type populations to improve cell type annotation, tissue registration, and clinical use cases. This paper presents scalable workflows to compute and use a curated dataset, called HRApop, with HRA cell type populations from high-quality single-cell (sc) transcriptomics and spatial, sc-proteomics datasets. For construction, 11,817 datasets with 33,996,049 cells were downloaded from four data portals; parsed and enriched with harmonized donor, 3D registration, and provenance metadata; annotated using Azimuth, Cell Typist, and popV; and published as Linked Open Data. 107 sc-proteomics datasets with 17,547,511 cells were added. HRApop v0.11.1 covers cell type populations for 59 unique anatomical structures across 15 organs derived from 619 datasets with 10,413,197 cells for 335 extraction sites. Resulting data was validated in terms of quality and coverage; spatial location and cell type annotation prediction accuracy; and hetero-/homogeneity of anatomical structures and organs.To show generalizability, the very same workflow was run for spatial, sc-proteomics datasets. All data and code is publicly available at [https://cns-iu.github.io/hra-cell-type-populations-supporting-information](https://cns-iu.github.io/hra-cell-type-populations-supporting-information).