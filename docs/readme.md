# **Companion Website for "Constructing and Using Cell Type Populations of the Human Reference Atlas"**

Andreas Bueckle<sup>1+</sup>\*, Bruce William Herr II<sup>1</sup>\*\*, Lu Chen<sup>2</sup>, Daniel Bolin<sup>1</sup>, Danial Qaurooni<sup>1</sup>, Michael Ginda<sup>1</sup>, , Kristin Ardlie<sup>3</sup>, Fusheng Wang<sup>2</sup>, Katy Börner<sup>1</sup>\*\*\*

<sup>1</sup> Department of Intelligent Systems Engineering, Luddy School of Informatics, Computing, and Engineering, Indiana University, Bloomington, IN 47408, USA \
<sup>2</sup> Department of Computer Science and Department of Biomedical Informatics, Stony Brook University, Stony Brook, 11794, NY, USA \
<sup>3</sup> Broad Institute, Cambridge, 02142, MA, USA \
\+ Lead contact\
\* Correspondence\
[abueckle@iu.edu](mailto:abueckle@iu.edu)\
[bherr@iu.edu](mailto:bherr@iu.edu)\
[katy@iu.edu](katy@iu.edu)


---

# Links
## General
- Link to paper on bioRxiv (forthcoming)
- [Link to GitHub repository for Supporting Information](https://github.com/cns-iu/hra-cell-type-populations-supporting-information)
- [Link to HRA Portal](https://humanatlas.io/)

## Portals
- [Link to HuBMAP Portal](https://portal.hubmapconsortium.org/)
- [Link to SenNet Portal](https://data.sennetconsortium.org/)
- [Link to GTEx Portal](https://gtexportal.org/home/)
- [Link to CZ CELLxGENE Portal](https://cellxgene.cziscience.com/)

## Code
- [Link to HRA Workflows](https://github.com/hubmapconsortium/hra-workflows/tree/main)
- [Link to HRA Workflows Runner](https://github.com/hubmapconsortium/hra-workflows-runner/)
- [Link to HRApop GitHub repository](https://github.com/x-atlas-consortia/hra-pop/tree/main/)

## Data
- [Link to HRApop graph data on HRA LOD server](https://cdn.humanatlas.io/digital-objects/graph/hra-pop/latest/)

# Interactive Sankey Diagrams

In total, as of HRApop v0.11.1, there are 11,817 datasets in the HRApop Universe (107 of which are sc-proteomics), and they cover 27 organs. 619 datasets make up the HRApop Atlas. 3680 datasets have an extraction site but no cell summary. Inversely, 5075 datasets have a cell summary but no extraction site. 2324 datasets have neither. The total number of non-atlas datasets is 11,198. The Sankey diagrams below offer an overview of HRApop Universe and Atlas provenance. 

Explore the Sankey diagram for the HRApop Universe below (embedded) or [here](https://cns-iu.github.io/hra-cell-type-populations-supporting-information/sankey_universe_plotly.html).
<iframe 
src="https://cns-iu.github.io/hra-cell-type-populations-supporting-information/sankey_universe_plotly.html" 
title="Sankey HRApop Universe"
  width="100%"
  height="800"
    frameborder="0" 
    allowfullscreen>
</iframe>

Explore the Sankey diagram for the HRApop Universe below (embedded) or [here](https://cns-iu.github.io/hra-cell-type-populations-supporting-information/sankey_atlas_plotly.html).
<iframe 
src="https://cns-iu.github.io/hra-cell-type-populations-supporting-information/sankey_atlas_plotly.html" 
title="Sankey HRApop Atlas"
  width="100%" 
  height="800"
    frameborder="0" 
    allowfullscreen>
</iframe>


# Bar Graphs for Cell Summaries
Shown here are bar graphs for…

# Number of Cell Types per Anatomical Structure 

See the table at [https://github.com/cns-iu/hra-cell-type-populations-supporting-information/blob/main/tables/output/table_SdataTableForAs.csv](https://github.com/cns-iu/hra-cell-type-populations-supporting-information/blob/main/tables/output/table_SdataTableForAs.csv).

# HRApop Extraction Sites
Assigning a spatial location via the Registration User Interface (RUI, [https://apps.humanatlas.io/rui](https://apps.humanatlas.io/rui/)) is an essential requirement for a dataset to be included in HRApop. Below is an instance of the Exploration User Interface (EUI, see federated version with all registered tissue blocks [here](https://apps.humanatlas.io/eui/)) that only shows extraction sites for datasets in HRApop.  

<a target="_blank" href="https://cns-iu.github.io/hra-cell-type-populations-supporting-information/eui.html"><img alt="load_button" width="84px" src="images/button_load.png" /></a>

<a target="_blank" href="https://cns-iu.github.io/hra-cell-type-populations-supporting-information/eui.html"><img alt="alt_text" width="75%" src="images/eui_preview.png"></a>

# Exemplary Cell Summaries

## For a Dataset

```json
  {
      "@id": "https://entity.api.hubmapconsortium.org/entities/1628b6f7eb615862322d6274a6bc9fa0",
      "@type": "Donor",
      "samples": [
        {
          "@id": "https://entity.api.hubmapconsortium.org/entities/0b43d8d0dbbc5e3923a8b963650ab8e3",
          "@type": "Sample",
          "datasets": [],
          "sections": [
            {
              "@id": "https://entity.api.hubmapconsortium.org/entities/35e16f13caab262f446836f63cf4ad42",
              "@type": "Sample",
              "datasets": [
                {
                  "@id": "https://entity.api.hubmapconsortium.org/entities/3de525fe3e5718f297e8d62e037a042d",
                  "@type": "Dataset",
                  "link": "https://portal.hubmapconsortium.org/browse/dataset/3de525fe3e5718f297e8d62e037a042d",
                  "technology": "RNAseq",
                  "cell_count": "6000",
                  "gene_count": "60286",
                  "organ_id": "http://purl.obolibrary.org/obo/UBERON_0002108",
                  "label": "Registered 11/3/2023, HuBMAP Process, TMC-Stanford",
                  "description": "Dataset Type: RNAseq [Salmon]",
                  "thumbnail": "assets/icons/ico-unknown.svg",
                  "summaries": [
                    {
                      "@type": "CellSummary",
                      "annotation_method": "celltypist",
                      "modality": "sc_transcriptomics",
                      "summary": [
                        {
                          "cell_id": "ASCTB-TEMP:enterocyte",
                          "cell_label": "Enterocyte",
                          "gene_expr": [
                            {
                              "gene_id": "HGNC:11036",
                              "gene_label": "SLC5A1",
                              "ensembl_id": "ENSG00000100170.10",
                              "mean_gene_expr_value": 3.376218795776367
                            },
                            {
                              "gene_id": "HGNC:7154",
                              "gene_label": "MME",
                              "ensembl_id": "ENSG00000196549.12",
                              "mean_gene_expr_value": 3.1750330924987793
                            },
                            {
                              "gene_id": "HGNC:10920",
                              "gene_label": "SLC15A1",
                              "ensembl_id": "ENSG00000088386.17",
                              "mean_gene_expr_value": 2.528520345687866
                            },
                            {
                              "gene_id": "HGNC:8747",
                              "gene_label": "PCSK5",
                              "ensembl_id": "ENSG00000099139.14",
                              "mean_gene_expr_value": 3.862326145172119
                            },
                            {
                              "gene_id": "HGNC:4212",
                              "gene_label": "GDA",
                              "ensembl_id": "ENSG00000119125.17",
                              "mean_gene_expr_value": 3.0900673866271973
                            },
                            {
                              "gene_id": "HGNC:2661",
                              "gene_label": "DAB1",
                              "ensembl_id": "ENSG00000173406.15",
                              "mean_gene_expr_value": 2.3853349685668945
                            },
                            {
                              "gene_id": "HGNC:2638",
                              "gene_label": "CYP3A5",
                              "ensembl_id": "ENSG00000106258.15",
                              "mean_gene_expr_value": 2.978743314743042
                            },
                            {
                              "gene_id": "ensembl:ENSG00000276490.1",
                              "gene_label": "ENSG00000276490.1",
                              "ensembl_id": "ENSG00000276490.1",
                              "mean_gene_expr_value": 2.3606600761413574
                            },
                            {
                              "gene_id": "HGNC:25835",
                              "gene_label": "THSD4",
                              "ensembl_id": "ENSG00000187720.14",
                              "mean_gene_expr_value": 2.495177745819092
                            },
                            {
                              "gene_id": "HGNC:10856",
                              "gene_label": "SI",
                              "ensembl_id": "ENSG00000090402.8",
                              "mean_gene_expr_value": 3.1366496086120605
                            }
                          ],
                          "count": 3600,
                          "@type": "CellSummaryRow",
                          "percentage": 0.6
                        }
										}
								}
						}
				}
	}
```

## For an AS

```json
  {
      "@type": "CellSummary",
      "sex": "Female",
      "cell_source": "http://purl.obolibrary.org/obo/UBERON_0002189",
      "cell_source_label": "outer cortex of kidney",
      "annotation_method": "azimuth",
      "aggregated_summary_count": 37,
      "aggregated_summaries": [
        {
          "aggregated_cell_source": "https://entity.api.hubmapconsortium.org/entities/367fee3b40cba682063289505b922be1",
          "percentage": 0.981
        },
        {
          "aggregated_cell_source": "https://entity.api.hubmapconsortium.org/entities/434fbc55d458dc4e06da9ba4961f3840",
          "percentage": 0.343
        },
        {
          "aggregated_cell_source": "https://entity.api.hubmapconsortium.org/entities/fbfdd102ecd60d7cf9d3da8c3d83a5c4",
          "percentage": 0.343
        },
        {
          "aggregated_cell_source": "https://entity.api.hubmapconsortium.org/entities/ac1d4544ab4886b851f74b2c21952378",
          "percentage": 0.343
        },
        {
          "aggregated_cell_source": "https://entity.api.hubmapconsortium.org/entities/e7bdf34c4da9f1d880f2615226e9713d",
          "percentage": 0.343
        },
        {
          "aggregated_cell_source": "https://entity.api.hubmapconsortium.org/entities/9b99c75de2347b9567e33065108488e8",
          "percentage": 0.343
        },
        {
          "aggregated_cell_source": "https://entity.api.hubmapconsortium.org/entities/aa93e53df10842c13348a334c8fe423f",
          "percentage": 0.343
        },
        {
          "aggregated_cell_source": "https://entity.api.hubmapconsortium.org/entities/254801a318687281ba3e473569d89a45",
          "percentage": 0.324
        },
        {
          "aggregated_cell_source": "https://entity.api.hubmapconsortium.org/entities/eb961e5dc50239d35f5398903c64e2b9",
          "percentage": 0.324
        },
        {
          "aggregated_cell_source": "https://entity.api.hubmapconsortium.org/entities/524dc341a03c155b6f4140e9d72f9b1d",
          "percentage": 0.961
        },
        {
          "aggregated_cell_source": "https://entity.api.hubmapconsortium.org/entities/e375a44f5cf5457c8f9b1132574c2436",
          "percentage": 0.961
        },
        {
          "aggregated_cell_source": "https://entity.api.hubmapconsortium.org/entities/2cd4eabca0b653af7f3b79534b2d641f",
          "percentage": 1
        },
        {
          "aggregated_cell_source": "https://entity.api.hubmapconsortium.org/entities/d1af36911148fdd7001fd4eebe7222f1",
          "percentage": 1
        },
        {
          "aggregated_cell_source": "https://entity.api.hubmapconsortium.org/entities/0a21f3fa27109790483f2a0729be53de",
          "percentage": 1
        },
        {
          "aggregated_cell_source": "https://entity.api.hubmapconsortium.org/entities/c1a0c043d0a986d71552091cc1b09742",
          "percentage": 1
        },
        {
          "aggregated_cell_source": "https://entity.api.hubmapconsortium.org/entities/7c9e07c96d144536525b1f889acee14d",
          "percentage": 0.5
        },
        {
          "aggregated_cell_source": "https://entity.api.hubmapconsortium.org/entities/898138b7f45a67c574e9955fb400e9be",
          "percentage": 0.5
        },
        {
          "aggregated_cell_source": "https://entity.api.hubmapconsortium.org/entities/08c1aa2e74700e1170fc9218ae255992",
          "percentage": 0.039
        },
        {
          "aggregated_cell_source": "https://entity.api.hubmapconsortium.org/entities/1197c73d127193dd493ff542890a3d3d",
          "percentage": 0.039
        },
        {
          "aggregated_cell_source": "https://entity.api.hubmapconsortium.org/entities/8c5e705001d5cc1c40dbd963ad848486",
          "percentage": 1
        },
        {
          "aggregated_cell_source": "https://entity.api.hubmapconsortium.org/entities/ccbad4ffd323265937b842ea36ada4ad",
          "percentage": 1
        },
        {
          "aggregated_cell_source": "https://entity.api.hubmapconsortium.org/entities/5039cf8619f6f8b5b4a14af1037e1d1f",
          "percentage": 1
        },
        {
          "aggregated_cell_source": "https://entity.api.hubmapconsortium.org/entities/7646a8a89555a123a56446b66c183d58",
          "percentage": 1
        },
        {
          "aggregated_cell_source": "https://api.cellxgene.cziscience.com/dp/v1/collections/bcb61471-2a44-4d00-a0af-ff085512674c#29-10012$cortex%20of%20kidney",
          "percentage": 0.9
        },
        {
          "aggregated_cell_source": "https://api.cellxgene.cziscience.com/dp/v1/collections/bcb61471-2a44-4d00-a0af-ff085512674c#30-10034$cortex%20of%20kidney",
          "percentage": 0.9
        },
        {
          "aggregated_cell_source": "https://api.cellxgene.cziscience.com/dp/v1/collections/bcb61471-2a44-4d00-a0af-ff085512674c#27-10039$kidney",
          "percentage": 0.9
        },
        {
          "aggregated_cell_source": "https://api.cellxgene.cziscience.com/dp/v1/collections/bcb61471-2a44-4d00-a0af-ff085512674c#29-10006$cortex%20of%20kidney",
          "percentage": 0.9
        },
        {
          "aggregated_cell_source": "https://api.cellxgene.cziscience.com/dp/v1/collections/bcb61471-2a44-4d00-a0af-ff085512674c#18-142$cortex%20of%20kidney",
          "percentage": 0.9
        },
        {
          "aggregated_cell_source": "https://api.cellxgene.cziscience.com/dp/v1/collections/bcb61471-2a44-4d00-a0af-ff085512674c#31-10035$cortex%20of%20kidney",
          "percentage": 0.9
        },
        {
          "aggregated_cell_source": "https://api.cellxgene.cziscience.com/dp/v1/collections/bcb61471-2a44-4d00-a0af-ff085512674c#29-10008$cortex%20of%20kidney",
          "percentage": 0.9
        },
        {
          "aggregated_cell_source": "https://api.cellxgene.cziscience.com/dp/v1/collections/bcb61471-2a44-4d00-a0af-ff085512674c#31-10042$kidney",
          "percentage": 0.9
        },
        {
          "aggregated_cell_source": "https://api.cellxgene.cziscience.com/dp/v1/collections/bcb61471-2a44-4d00-a0af-ff085512674c#18-162$cortex%20of%20kidney",
          "percentage": 0.9
        },
        {
          "aggregated_cell_source": "https://api.cellxgene.cziscience.com/dp/v1/collections/bcb61471-2a44-4d00-a0af-ff085512674c#29-10016$kidney",
          "percentage": 0.9
        },
        {
          "aggregated_cell_source": "https://api.cellxgene.cziscience.com/dp/v1/collections/bcb61471-2a44-4d00-a0af-ff085512674c#34-10050$kidney",
          "percentage": 0.9
        },
        {
          "aggregated_cell_source": "https://api.cellxgene.cziscience.com/dp/v1/collections/bcb61471-2a44-4d00-a0af-ff085512674c#34-10184$kidney",
          "percentage": 0.9
        },
        {
          "aggregated_cell_source": "https://api.cellxgene.cziscience.com/dp/v1/collections/bcb61471-2a44-4d00-a0af-ff085512674c#31-10040$kidney",
          "percentage": 0.9
        },
        {
          "aggregated_cell_source": "https://api.cellxgene.cziscience.com/dp/v1/collections/bcb61471-2a44-4d00-a0af-ff085512674c#29-10011$kidney",
          "percentage": 0.9
        }
      ]
	}
```