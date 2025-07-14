<script type="module" src="https://unpkg.com/@google/model-viewer/dist/model-viewer.min.js"></script>

# **Companion Website for "Constructing and Using Cell Type Populations of the Human Reference Atlas"**

Andreas Bueckle<sup>1</sup>\*, Bruce W. Herr II<sup>1</sup>\*, Lu Chen<sup>2</sup>, Daniel Bolin<sup>1</sup>, Danial Qaurooni<sup>1</sup>, Michael Ginda<sup>1</sup>, Yashvardhan Jain<sup>1</sup>, Aleix Puig Barbé <sup>3</sup>, Kristin Ardlie<sup>4</sup>, Fusheng Wang<sup>2</sup>, Katy Börner<sup>1</sup>\*

<sup>1</sup> Department of Intelligent Systems Engineering, Luddy School of Informatics, Computing, and Engineering, Indiana University, Bloomington, IN 47408, USA \
<sup>2</sup> Department of Computer Science and Department of Biomedical Informatics, Stony Brook University, Stony Brook, 11794, NY, USA \
<sup>3</sup> European Bioinformatics Institute (EMBL-EBI), Wellcome Genome Campus, Hinxton, Cambridge CB10 1SD, UK\
<sup>4</sup> Broad Institute, Cambridge, 02142, MA, USA \
\* Corresponding authors\
[abueckle@iu.edu](mailto:abueckle@iu.edu)\
[bherr@iu.edu](mailto:bherr@iu.edu)\
[katy@iu.edu](katy@iu.edu)


---

# Links
## General
- Link to paper on bioRxiv (forthcoming)
- [Link to GitHub repository for Supporting Information](https://github.com/cns-iu/hra-cell-type-populations-supporting-information)
- [Link to HuBMAP Publication page with links to all HuBMAP datasets, tissue, blocks, and donors used for the HRApop v1.0](https://portal.hubmapconsortium.org/browse/publication/f53d60b5994333777a446dd7ad3b0304)
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

# Figures
![](images/HRApop%20Figures_Figure%20SheatmapTranscriptomics.png)

**Figure C1**. Mean scores for cell types (x-axis) from sc-transcriptomics datasets across organs and AS (y-axis) for (a) Azimuth, (b) CellTypist, and (c) popV.

![](images/HRApop%20Figures_Figure%20SheatmapProteomics.png)

**Figure C2**. Mean scores for cell types (x-axis) from sc-proteomics datasets across organs and AS (y-axis).

# Usage examples

## Accessing HRApop data
A Jupyter Notebook detailing easy access to cell type populations for AS, extraction sites, and datasets is available at [https://github.com/cns-iu/hra-cell-type-populations-supporting-information/blob/main/notebooks/hra-pop-grlc-queries.ipynb](https://github.com/cns-iu/hra-cell-type-populations-supporting-information/blob/main/notebooks/hra-pop-grlc-queries.ipynb). 

## Visualizing Cell Type Populations for AS, ES, and Datasets
The web interface at XXXXXXXX enables users to create stacked bar graphs for AS, ES, and Datasets, separated by sex and tool.  

## Running HRA Workflows Runner on a local H5AD file
A notebook to run the HRA Workflows Runner on Windows with Windows Subsystem for Linux (WSL) is provided at [https://github.com/cns-iu/hra-pop-notebooks/blob/main/annotations/hra-workflows-runner-local-run.ipynb](https://github.com/cns-iu/hra-pop-notebooks/blob/main/annotations/hra-workflows-runner-local-run.ipynb). The code also shows how to get confidence scores for each individual cell in addition to cell type populations with biomarker expression values per CT. Finally, this notebook demonstrates how to transform the output from the DCTA Workflow and return confidence scores + a CSV file for the cell type population that the user can then use on [https://apps.humanatlas.io/us2](https://apps.humanatlas.io/us2), using either the web interface or the HRA API ([https://humanatlas.io/user-story/2#apis](https://humanatlas.io/user-story/2#apis)). 

## Step-by-step instructions
**Goal: get Mean B Expressions for a given CT in HRApop Atlas Datasets**

1. When opening [https://apps.humanatlas.io/api/grlc/hra-pop.html#get-/datasets-with-ct](https://apps.humanatlas.io/api/grlc/hra-pop.html#get-/datasets-with-ct), the first item shown is the SPARQL query running when the endpoint is called:
![](images/steps_1.png)

2. Below, you can specify your request. The only mandatory field is the `celltype`, which must be a Persistent URL (PURL). You can click the FILL EXAMPLE button to prefill this field with `http://purl.obolibrary.org/obo/CL_0000136`, which is `adipocyte`. Clickt the TRY button to run the query. 
![](images/steps_2.png)

3. Then, the response area presents the result of the query, which consists of a table with one CT-B record per row. You may copy the results to your clipboard with the COPY button. 
![](images/steps_3.png)

4. You can also click the tabs in the response area to get the `CURL` command to run the query for the same results:
![](images/steps_4.png)

# Interactive Sankey diagrams

In total, as of HRApop v1.0, there are 16,293 datasets in the HRApop Universe (558 of which are sc-transcriptomics and 104 of which are sc-proteomics), and they cover 49 organs. 662 datasets make up the HRApop Atlas. 5,672 datasets have an extraction site but no cell type population. Inversely, 6,395 datasets have a cell type population but no extraction site. 3,564 datasets have neither. The total number of non-atlas datasets is 15,631. The Sankey diagrams below offer an overview of HRApop Universe and Atlas provenance. 

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

# HRApop Atlas Data extraction sites
Assigning a spatial location via the Registration User Interface (RUI, [https://apps.humanatlas.io/rui](https://apps.humanatlas.io/rui/)) is an essential requirement for a dataset to be included in HRApop. Below is an instance of the Exploration User Interface (EUI, see federated version with all registered tissue blocks [here](https://apps.humanatlas.io/eui/)) that only shows extraction sites for HRApop Atlas Data.  

<a target="_blank" href="https://cns-iu.github.io/hra-cell-type-populations-supporting-information/eui.html"><img alt="load_button" width="84px" src="images/button_load.png" /></a>

<div class ="iframe-container">
<iframe src="https://cns-iu.github.io/hra-cell-type-populations-supporting-information/eui.html" title="EUI for HRApop">
</iframe>
</div>

<style>
  .iframe-container {
    position: relative;
    width: 100%;
    padding-top: 56.25%; /* 16:9 aspect ratio (9 / 16 = 0.5625) */
    overflow: hidden;
    border-radius: 12px; /* optional: rounded corners */
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1); /* optional: soft shadow */
  }

  .iframe-container iframe {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    border: none;
  }
</style>

# z-scores for CTs per organ and AS
- High-resolution versions of the heatmaps are available [here](https://github.com/cns-iu/hra-cell-type-populations-supporting-information/tree/main/validations/heatmaps/figs). 
- The code to generate these heatmaps (exported to HTML) is [here](https://cns-iu.github.io/hra-cell-type-populations-supporting-information/HRA_HeatmapAnalysis_CellTypePer_v0.4.html). 
- The R Markdown notebook is [here](https://github.com/cns-iu/hra-cell-type-populations-supporting-information/blob/main/validations/heatmaps/HRA_HeatmapAnalysis_CellTypePer_v0.4.Rmd).

# Exemplary corridor

<div style="width: 100%; height: 500px;">
  <model-viewer 
    src="data/1cbd9283-2d58-4a2d-88fe-effb18c3f14f.glb" 
    alt="Corridor for extraction site in female pancreas" 
    auto-rotate 
    camera-controls 
    touch-action="pan-y"
    shadow-intensity="1" 
    ar 
    style="width: 100%; height: 100%;">
  </model-viewer>
</div>





# Exemplary cell type populations

## For a dataset

Shown is a snippet from a cell type population for a dataset in the small intestine, taken from a Dataset and Extraction Site Cell Type Population (DESpop). For clarity, we only show four CTs in this cell type population, all assigned by CellTypist, and we only show the top 10 Bs one CT (`Tuft`).

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
                           ...
                          ],
                          "count": 3600,
                          "@type": "CellSummaryRow",
                          "percentage": 0.6
                        },
                        {
                          "cell_id": "ASCTB-TEMP:paneth",
                          "cell_label": "Paneth",
                          "gene_expr": [
                            ...
                            ],
                          "count": 265,
                          "@type": "CellSummaryRow",
                          "percentage": 0.04416666666666667
                        },
                        {
                          "cell_id": "ASCTB-TEMP:cycling-b-cell",
                          "cell_label": "Cycling B cell",
                          "gene_expr": [
                          ...
                          ],
                          "count": 43,
                          "@type": "CellSummaryRow",
                          "percentage": 0.007166666666666667
                        },
                        {
                          "cell_id": "ASCTB-TEMP:tuft",
                          "cell_label": "Tuft",
                          "gene_expr": [
                            {
                              "gene_id": "HGNC:29349",
                              "gene_label": "CCSER1",
                              "ensembl_id": "ENSG00000184305.15",
                              "mean_gene_expr_value": 3.573841094970703
                            },
                            {
                              "gene_id": "HGNC:18695",
                              "gene_label": "ST18",
                              "ensembl_id": "ENSG00000147488.11",
                              "mean_gene_expr_value": 2.0579261779785156
                            },
                            {
                              "gene_id": "HGNC:4036",
                              "gene_label": "FYB1",
                              "ensembl_id": "ENSG00000082074.18",
                              "mean_gene_expr_value": 2.106393337249756
                            },
                            {
                              "gene_id": "HGNC:10471",
                              "gene_label": "RUNX1",
                              "ensembl_id": "ENSG00000159216.19",
                              "mean_gene_expr_value": 2.0352487564086914
                            },
                            {
                              "gene_id": "HGNC:8783",
                              "gene_label": "PDE4D",
                              "ensembl_id": "ENSG00000113448.19",
                              "mean_gene_expr_value": 3.152188539505005
                            },
                            {
                              "gene_id": "HGNC:1079",
                              "gene_label": "BMX",
                              "ensembl_id": "ENSG00000102010.15",
                              "mean_gene_expr_value": 1.6486668586730957
                            },
                            {
                              "gene_id": "HGNC:13726",
                              "gene_label": "KMT2C",
                              "ensembl_id": "ENSG00000055609.19",
                              "mean_gene_expr_value": 2.2729785442352295
                            },
                            {
                              "gene_id": "HGNC:9066",
                              "gene_label": "PLCG2",
                              "ensembl_id": "ENSG00000197943.10",
                              "mean_gene_expr_value": 2.123337507247925
                            },
                            {
                              "gene_id": "HGNC:27363",
                              "gene_label": "ITPRID1",
                              "ensembl_id": "ENSG00000180347.13",
                              "mean_gene_expr_value": 1.7490202188491821
                            },
                            {
                              "gene_id": "HGNC:17890",
                              "gene_label": "HPGDS",
                              "ensembl_id": "ENSG00000163106.11",
                              "mean_gene_expr_value": 1.5961321592330933
                            }
                          ],
                          "count": 41,
                          "@type": "CellSummaryRow",
                          "percentage": 0.006833333333333334
                        }
	}
```

## For an extraction site

Shown is a cell type population for an extraction site, taken from a Dataset and Extraction Site Cell Type Population (DESpop). All mesh-based collisions are listed in the `all_collisions` field. The corresponding corridor is described and linked in the `corridor` field. The `summaries` key contains the cell type population.

```json
"rui_location": {
      "@context": "https://hubmapconsortium.github.io/ccf-ontology/ccf-context.jsonld",
      "@id": "http://purl.org/ccf/1.5/e240c0a4-5e53-4464-8320-ad775f2c4bf7",
      "@type": "SpatialEntity",
      "ccf_annotations": [
       "http://purl.obolibrary.org/obo/UBERON_0002115",
       "http://purl.obolibrary.org/obo/UBERON_0002116"
      ],
      "creation_date": "2022-02-16",
      "creator": "Yiing Lin",
      "creator_first_name": "Yiing",
      "creator_last_name": "Lin",
      "dimension_units": "millimeter",
      "placement": {
       "@context": "https://hubmapconsortium.github.io/hubmap-ontology/ccf-context.jsonld",
       "@id": "http://purl.org/ccf/1.5/e240c0a4-5e53-4464-8320-ad775f2c4bf7_placement",
       "@type": "SpatialPlacement",
       "placement_date": "2022-02-16",
       "rotation_order": "XYZ",
       "rotation_units": "degree",
       "scaling_units": "ratio",
       "target": "http://purl.org/ccf/latest/ccf.owl#VHFSmallIntestine",
       "translation_units": "millimeter",
       "x_rotation": 0,
       "x_scaling": 1,
       "x_translation": 130.806,
       "y_rotation": 0,
       "y_scaling": 1,
       "y_translation": 111.09,
       "z_rotation": 86,
       "z_scaling": 1,
       "z_translation": 54.023
      },
      "x_dimension": 3,
      "y_dimension": 30,
      "z_dimension": 15,
      "all_collisions": [
       {
        "@type": "CollisionSummary",
        "collision_method": "MESH",
        "collisions": [
         {
          "@type": "CollisionItem",
          "reference_organ": "http://purl.org/ccf/latest/ccf.owl#VHFSmallIntestine",
          "as_3d_id": "https://purl.humanatlas.io/ref-organ/small-intestine-female/v1.2#VH_F_jejenum",
          "as_id": "http://purl.obolibrary.org/obo/UBERON_0002115",
          "as_label": "jejunum",
          "as_volume": 28523.456808180017,
          "percentage": 0.103
         }
        ]
       }
      ],
      "corridor": {
       "@type": "Corridor",
       "file_format": "model/gltf-binary",
       "file": "https://cdn.humanatlas.io/digital-objects/graph/hra-pop/v1.0/assets/corridors/e240c0a4-5e53-4464-8320-ad775f2c4bf7.glb"
      },
      "summaries": [
       {
        "@type": "CellSummary",
        "sex": "Female",
        "annotation_method": "celltypist",
        "aggregated_summary_count": 1,
        "aggregated_summaries": [
         {
          "aggregated_cell_source": "https://entity.api.hubmapconsortium.org/entities/3de525fe3e5718f297e8d62e037a042d",
          "percentage": 1
         }
        ],
        "modality": "sc_transcriptomics",
        "summary": [
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:enterocyte",
          "cell_label": "Enterocyte",
          "count": 3598,
          "percentage": 0.5996666666666667
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:paneth",
          "cell_label": "Paneth",
          "count": 265,
          "percentage": 0.04416666666666667
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:cycling-b-cell",
          "cell_label": "Cycling B cell",
          "count": 43,
          "percentage": 0.007166666666666667
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:tuft",
          "cell_label": "Tuft",
          "count": 41,
          "percentage": 0.006833333333333334
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:trgv2-gdt",
          "cell_label": "TRGV2 gdT",
          "count": 120,
          "percentage": 0.02
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:stem-cells",
          "cell_label": "Stem cells",
          "count": 110,
          "percentage": 0.018333333333333333
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:best4-epithelial",
          "cell_label": "BEST4+ epithelial",
          "count": 124,
          "percentage": 0.020666666666666667
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:goblet-cell",
          "cell_label": "Goblet cell",
          "count": 289,
          "percentage": 0.04816666666666667
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:myofibroblast",
          "cell_label": "myofibroblast",
          "count": 57,
          "percentage": 0.0095
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:eecs",
          "cell_label": "EECs",
          "count": 251,
          "percentage": 0.041833333333333333
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:activated-t",
          "cell_label": "Activated T",
          "count": 47,
          "percentage": 0.007833333333333333
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:mature-arterial-ec",
          "cell_label": "Mature arterial EC",
          "count": 11,
          "percentage": 0.0018333333333333333
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:branch-a1-imn-",
          "cell_label": "Branch A1 (iMN)",
          "count": 3,
          "percentage": 0.0005
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:memory-b",
          "cell_label": "Memory B",
          "count": 13,
          "percentage": 0.0021666666666666666
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:mesoderm-1-hand1-",
          "cell_label": "Mesoderm 1 (HAND1+)",
          "count": 5,
          "percentage": 0.0008333333333333334
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:stat1-naive-b",
          "cell_label": "STAT1+ Naive B",
          "count": 21,
          "percentage": 0.0035
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:microfold-cell",
          "cell_label": "Microfold cell",
          "count": 198,
          "percentage": 0.033
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:proximal-progenitor",
          "cell_label": "Proximal progenitor",
          "count": 106,
          "percentage": 0.017666666666666667
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:stromal-1-ccl11-",
          "cell_label": "Stromal 1 (CCL11+)",
          "count": 23,
          "percentage": 0.003833333333333333
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:branch-b1-emn-",
          "cell_label": "Branch B1 (eMN)",
          "count": 31,
          "percentage": 0.005166666666666667
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:stromal-2-npy-",
          "cell_label": "Stromal 2 (NPY+)",
          "count": 12,
          "percentage": 0.002
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:ec-cells-tac1-",
          "cell_label": "EC cells (TAC1+)",
          "count": 20,
          "percentage": 0.0033333333333333335
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:i-cells-cck-",
          "cell_label": "I cells (CCK+)",
          "count": 26,
          "percentage": 0.004333333333333333
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:smc-part1-capn3-",
          "cell_label": "SMC (PART1/CAPN3+)",
          "count": 6,
          "percentage": 0.001
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:arterial-capillary",
          "cell_label": "arterial capillary",
          "count": 30,
          "percentage": 0.005
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:lyve1-macrophage",
          "cell_label": "LYVE1+ Macrophage",
          "count": 18,
          "percentage": 0.003
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:m-x-cells-mln-ghrl-",
          "cell_label": "M/X cells (MLN/GHRL+)",
          "count": 12,
          "percentage": 0.002
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:tfh",
          "cell_label": "Tfh",
          "count": 33,
          "percentage": 0.0055
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:stromal-3-kcnn3-",
          "cell_label": "Stromal 3 (KCNN3+)",
          "count": 18,
          "percentage": 0.003
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:mlto",
          "cell_label": "mLTo",
          "count": 5,
          "percentage": 0.0008333333333333334
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:lec6-adamts4-",
          "cell_label": "LEC6 (ADAMTS4+)",
          "count": 2,
          "percentage": 0.0003333333333333333
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:glia-1-dhh-",
          "cell_label": "Glia 1 (DHH+)",
          "count": 2,
          "percentage": 0.0003333333333333333
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:cycling-ec",
          "cell_label": "cycling EC",
          "count": 20,
          "percentage": 0.0033333333333333335
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:d-cells-sst-",
          "cell_label": "D cells (SST+)",
          "count": 10,
          "percentage": 0.0016666666666666668
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:myofibroblast-rspo2-",
          "cell_label": "myofibroblast (RSPO2+)",
          "count": 30,
          "percentage": 0.005
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:contractile-pericyte-pln-",
          "cell_label": "Contractile pericyte (PLN+)",
          "count": 20,
          "percentage": 0.0033333333333333335
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:t-reticular",
          "cell_label": "T reticular",
          "count": 5,
          "percentage": 0.0008333333333333334
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:colonocyte",
          "cell_label": "Colonocyte",
          "count": 4,
          "percentage": 0.0006666666666666666
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:cd8-tmem",
          "cell_label": "CD8 Tmem",
          "count": 7,
          "percentage": 0.0011666666666666668
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:cycling-plasma-cell",
          "cell_label": "Cycling plasma cell",
          "count": 28,
          "percentage": 0.004666666666666667
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:lec4-stab2-",
          "cell_label": "LEC4 (STAB2+)",
          "count": 10,
          "percentage": 0.0016666666666666668
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:dz-gc-cell",
          "cell_label": "DZ GC cell",
          "count": 16,
          "percentage": 0.0026666666666666666
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:angiogenic-pericyte",
          "cell_label": "angiogenic pericyte",
          "count": 2,
          "percentage": 0.0003333333333333333
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:fdc",
          "cell_label": "FDC",
          "count": 4,
          "percentage": 0.0006666666666666666
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:stromal-3-c7-",
          "cell_label": "Stromal 3 (C7+)",
          "count": 13,
          "percentage": 0.0021666666666666666
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:progenitor-neurog3-",
          "cell_label": "Progenitor (NEUROG3+)",
          "count": 12,
          "percentage": 0.002
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:pdc",
          "cell_label": "pDC",
          "count": 5,
          "percentage": 0.0008333333333333334
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:mature-venous-ec",
          "cell_label": "Mature venous EC",
          "count": 21,
          "percentage": 0.0035
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:lti-like-ncr-ilc3",
          "cell_label": "LTi-like NCR- ILC3",
          "count": 6,
          "percentage": 0.001
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:mait-cell",
          "cell_label": "MAIT cell",
          "count": 2,
          "percentage": 0.0003333333333333333
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:trdv2-trgv9-gdt",
          "cell_label": "TRDV2/TRGV9 gdT",
          "count": 19,
          "percentage": 0.0031666666666666666
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:nk-cell",
          "cell_label": "NK cell",
          "count": 25,
          "percentage": 0.004166666666666667
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:glia-3-bcan-",
          "cell_label": "Glia 3 (BCAN+)",
          "count": 7,
          "percentage": 0.0011666666666666668
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:activated-cd8-t",
          "cell_label": "Activated CD8 T",
          "count": 2,
          "percentage": 0.0003333333333333333
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:neuroblast",
          "cell_label": "Neuroblast",
          "count": 1,
          "percentage": 0.00016666666666666666
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:distal-progenitor",
          "cell_label": "Distal progenitor",
          "count": 3,
          "percentage": 0.0005
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:macrophages",
          "cell_label": "Macrophages",
          "count": 15,
          "percentage": 0.0025
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:mast-cell",
          "cell_label": "Mast cell",
          "count": 3,
          "percentage": 0.0005
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:trgv4-gdt",
          "cell_label": "TRGV4 gdT",
          "count": 22,
          "percentage": 0.0036666666666666666
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:icc",
          "cell_label": "ICC",
          "count": 1,
          "percentage": 0.00016666666666666666
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:k-cells-gip-",
          "cell_label": "K cells (GIP+)",
          "count": 8,
          "percentage": 0.0013333333333333333
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:pre-b",
          "cell_label": "Pre-B",
          "count": 7,
          "percentage": 0.0011666666666666668
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:l-cells-pyy-",
          "cell_label": "L cells (PYY+)",
          "count": 11,
          "percentage": 0.0018333333333333333
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:smc-plpp2-",
          "cell_label": "SMC (PLPP2+)",
          "count": 16,
          "percentage": 0.0026666666666666666
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:adult-glia",
          "cell_label": "Adult Glia",
          "count": 10,
          "percentage": 0.0016666666666666668
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:th1",
          "cell_label": "Th1",
          "count": 4,
          "percentage": 0.0006666666666666666
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:branch-b3-ipan-",
          "cell_label": "Branch B3 (IPAN)",
          "count": 2,
          "percentage": 0.0003333333333333333
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:ta",
          "cell_label": "TA",
          "count": 13,
          "percentage": 0.0021666666666666666
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:sell-cd4-t",
          "cell_label": "SELL+ CD4 T",
          "count": 2,
          "percentage": 0.0003333333333333333
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:branch-a2-ipan-in-",
          "cell_label": "Branch A2 (IPAN/IN)",
          "count": 8,
          "percentage": 0.0013333333333333333
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:immature-pericyte",
          "cell_label": "Immature pericyte",
          "count": 4,
          "percentage": 0.0006666666666666666
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:clp",
          "cell_label": "CLP",
          "count": 3,
          "percentage": 0.0005
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:cycling-stromal",
          "cell_label": "cycling stromal",
          "count": 1,
          "percentage": 0.00016666666666666666
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:transitional-stromal-3-c3-",
          "cell_label": "Transitional Stromal 3 (C3+)",
          "count": 3,
          "percentage": 0.0005
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:branch-a4-in-",
          "cell_label": "Branch A4 (IN)",
          "count": 5,
          "percentage": 0.0008333333333333334
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:lec1-ackr4-",
          "cell_label": "LEC1 (ACKR4+)",
          "count": 1,
          "percentage": 0.00016666666666666666
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:lec3-adgrg3-",
          "cell_label": "LEC3 (ADGRG3+)",
          "count": 2,
          "percentage": 0.0003333333333333333
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:monocytes",
          "cell_label": "Monocytes",
          "count": 3,
          "percentage": 0.0005
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:sell-cd8-t",
          "cell_label": "SELL+ CD8 T",
          "count": 2,
          "percentage": 0.0003333333333333333
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:-cells-ins-",
          "cell_label": "β cells (INS+)",
          "count": 1,
          "percentage": 0.00016666666666666666
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:mesothelium-rgs5-",
          "cell_label": "Mesothelium (RGS5+)",
          "count": 2,
          "percentage": 0.0003333333333333333
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:nk-t-cell",
          "cell_label": "NK T cell",
          "count": 2,
          "percentage": 0.0003333333333333333
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:activated-cd4-t",
          "cell_label": "Activated CD4 T",
          "count": 2,
          "percentage": 0.0003333333333333333
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:pericyte",
          "cell_label": "Pericyte",
          "count": 3,
          "percentage": 0.0005
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:fetal-venous-ec",
          "cell_label": "Fetal venous EC",
          "count": 4,
          "percentage": 0.0006666666666666666
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:fcrl4-memory-b",
          "cell_label": "FCRL4+ Memory B",
          "count": 3,
          "percentage": 0.0005
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:cdc1",
          "cell_label": "cDC1",
          "count": 3,
          "percentage": 0.0005
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:lz-gc-cell",
          "cell_label": "LZ GC cell",
          "count": 2,
          "percentage": 0.0003333333333333333
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:gc-b-cell",
          "cell_label": "GC B cell",
          "count": 2,
          "percentage": 0.0003333333333333333
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:venous-capillary",
          "cell_label": "venous capillary",
          "count": 1,
          "percentage": 0.00016666666666666666
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:cldn10-cells",
          "cell_label": "CLDN10+ cells",
          "count": 1,
          "percentage": 0.00016666666666666666
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:lymphoid-dc",
          "cell_label": "Lymphoid DC",
          "count": 1,
          "percentage": 0.00016666666666666666
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:mmp9-inflammatory-macrophage",
          "cell_label": "MMP9+ Inflammatory macrophage",
          "count": 1,
          "percentage": 0.00016666666666666666
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:pro-b",
          "cell_label": "Pro-B",
          "count": 1,
          "percentage": 0.00016666666666666666
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:branch-b2-emn-",
          "cell_label": "Branch B2 (eMN)",
          "count": 3,
          "percentage": 0.0005
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:naive-b",
          "cell_label": "Naive B",
          "count": 3,
          "percentage": 0.0005
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:treg",
          "cell_label": "Treg",
          "count": 2,
          "percentage": 0.0003333333333333333
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:stromal-2-ch25h-",
          "cell_label": "Stromal 2 (CH25H+)",
          "count": 1,
          "percentage": 0.00016666666666666666
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:best2-goblet-cell",
          "cell_label": "BEST2+ Goblet cell",
          "count": 1,
          "percentage": 0.00016666666666666666
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:lec2-madcam1-",
          "cell_label": "LEC2 (MADCAM1+)",
          "count": 1,
          "percentage": 0.00016666666666666666
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:ilc2",
          "cell_label": "ILC2",
          "count": 1,
          "percentage": 0.00016666666666666666
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "ASCTB-TEMP:stromal-1-adamdec1-",
          "cell_label": "Stromal 1 (ADAMDEC1+)",
          "count": 1,
          "percentage": 0.00016666666666666666
         }
        ]
       },
       {
        "@type": "CellSummary",
        "sex": "Female",
        "annotation_method": "popv",
        "aggregated_summary_count": 1,
        "aggregated_summaries": [
         {
          "aggregated_cell_source": "https://entity.api.hubmapconsortium.org/entities/3de525fe3e5718f297e8d62e037a042d",
          "percentage": 1
         }
        ],
        "modality": "sc_transcriptomics",
        "summary": [
         {
          "@type": "CellSummaryRow",
          "cell_id": "CL:1000334",
          "cell_label": "enterocyte of epithelium of small intestine",
          "count": 5408,
          "percentage": 0.9016338779593198
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "CL:1000343",
          "cell_label": "paneth cell of epithelium of small intestine",
          "count": 192,
          "percentage": 0.032010670223407804
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "CL:1000495",
          "cell_label": "small intestine goblet cell",
          "count": 215,
          "percentage": 0.035845281760586864
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "CL:0009006",
          "cell_label": "intestinal enteroendocrine cell",
          "count": 44,
          "percentage": 0.007335778592864288
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "CL:0009012",
          "cell_label": "transit amplifying cell of small intestine",
          "count": 10,
          "percentage": 0.0016672224074691564
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "CL:0009080",
          "cell_label": "intestinal tuft cell",
          "count": 26,
          "percentage": 0.004334778259419807
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "CL:0000057",
          "cell_label": "fibroblast",
          "count": 41,
          "percentage": 0.006835611870623541
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "CL:0000131",
          "cell_label": "gut endothelial cell",
          "count": 14,
          "percentage": 0.002334111370456819
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "CL:0000775",
          "cell_label": "neutrophil",
          "count": 38,
          "percentage": 0.006335445148382794
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "CL:0000624",
          "cell_label": "CD4-positive, alpha-beta T cell",
          "count": 1,
          "percentage": 0.00016672224074691563
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "CL:0000625",
          "cell_label": "CD8-positive, alpha-beta T cell",
          "count": 6,
          "percentage": 0.0010003334444814939
         },
         {
          "@type": "CellSummaryRow",
          "cell_id": "CL:0000786",
          "cell_label": "plasma cell",
          "count": 3,
          "percentage": 0.0005001667222407469
         }
        ]
       }
      ]
     }
```

## For an AS

Shown is a snippet from the AS Cell Type Population of the cortex of kidney, assigned by Azimuth, taken from a AS Cell Type Population (ASpop). 

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
        ...],
      "modality": "sc_transcriptomics",
      "summary": [
        {
          "@type": "CellSummaryRow",
          "cell_id": "CL:1000692",
          "cell_label": "Fibroblast",
          "count": 10336.100000000002,
          "percentage": 0.01925307293655101
        },
        {
          "@type": "CellSummaryRow",
          "cell_id": "CL:1001108",
          "cell_label": "Medullary Thick Ascending Limb",
          "count": 26758.349000000002,
          "percentage": 0.04984282707778434
        },
        {
          "@type": "CellSummaryRow",
          "cell_id": "CL:4030013",
          "cell_label": "Descending Thin Limb Type 2",
          "count": 31925.262000000002,
          "percentage": 0.05946724565401847
        }
        ...
	}
```

# Dataset counts

| as_label_organ                                                                                 	| tool       	| sex    	| dataset 	|
|------------------------------------------------------------------------------------------------	|------------	|--------	|---------	|
| Set of lactiferous glands in left breast   - Interlobar adipose tissue of left mammary gland   	| popv       	| Female 	| 2       	|
| Set of lactiferous glands in left breast   - main lactiferous duct                             	| popv       	| Female 	| 2       	|
| Set of lactiferous glands in left breast   - mammary lobe                                      	| popv       	| Female 	| 2       	|
| Set of lactiferous glands in right breast   - Interlobar adipose tissue of right mammary gland 	| popv       	| Female 	| 3       	|
| Set of lactiferous glands in right breast   - main lactiferous duct                            	| popv       	| Female 	| 3       	|
| heart - Posteromedial head of posterior   papillary muscle of left ventricle                   	| azimuth    	| Female 	| 6       	|
| heart - Posteromedial head of posterior   papillary muscle of left ventricle                   	| celltypist 	| Female 	| 6       	|
| heart - heart left ventricle                                                                   	| azimuth    	| Female 	| 28      	|
| heart - heart left ventricle                                                                   	| azimuth    	| Male   	| 37      	|
| heart - heart left ventricle                                                                   	| celltypist 	| Female 	| 28      	|
| heart - heart left ventricle                                                                   	| celltypist 	| Male   	| 37      	|
| heart - heart right ventricle                                                                  	| azimuth    	| Female 	| 14      	|
| heart - heart right ventricle                                                                  	| azimuth    	| Male   	| 16      	|
| heart - heart right ventricle                                                                  	| celltypist 	| Female 	| 14      	|
| heart - heart right ventricle                                                                  	| celltypist 	| Male   	| 16      	|
| heart - interventricular septum                                                                	| azimuth    	| Female 	| 7       	|
| heart - interventricular septum                                                                	| azimuth    	| Male   	| 8       	|
| heart - interventricular septum                                                                	| celltypist 	| Female 	| 7       	|
| heart - interventricular septum                                                                	| celltypist 	| Male   	| 8       	|
| heart - left cardiac atrium                                                                    	| azimuth    	| Female 	| 7       	|
| heart - left cardiac atrium                                                                    	| azimuth    	| Male   	| 7       	|
| heart - left cardiac atrium                                                                    	| celltypist 	| Female 	| 7       	|
| heart - left cardiac atrium                                                                    	| celltypist 	| Male   	| 7       	|
| heart - right cardiac atrium                                                                   	| azimuth    	| Female 	| 9       	|
| heart - right cardiac atrium                                                                   	| azimuth    	| Male   	| 8       	|
| heart - right cardiac atrium                                                                   	| celltypist 	| Female 	| 9       	|
| heart - right cardiac atrium                                                                   	| celltypist 	| Male   	| 8       	|
| large intestine - ascending colon                                                              	| celltypist 	| Female 	| 6       	|
| large intestine - ascending colon                                                              	| celltypist 	| Male   	| 8       	|
| large intestine - ascending colon                                                              	| popv       	| Female 	| 6       	|
| large intestine - ascending colon                                                              	| popv       	| Male   	| 8       	|
| large intestine - caecum                                                                       	| celltypist 	| Female 	| 3       	|
| large intestine - caecum                                                                       	| celltypist 	| Male   	| 1       	|
| large intestine - caecum                                                                       	| popv       	| Female 	| 3       	|
| large intestine - caecum                                                                       	| popv       	| Male   	| 1       	|
| large intestine - descending colon                                                             	| celltypist 	| Female 	| 4       	|
| large intestine - descending colon                                                             	| celltypist 	| Male   	| 7       	|
| large intestine - descending colon                                                             	| popv       	| Female 	| 4       	|
| large intestine - descending colon                                                             	| popv       	| Male   	| 7       	|
| large intestine - hepatic flexure of   colon                                                   	| celltypist 	| Female 	| 3       	|
| large intestine - hepatic flexure of   colon                                                   	| celltypist 	| Male   	| 1       	|
| large intestine - hepatic flexure of   colon                                                   	| popv       	| Female 	| 3       	|
| large intestine - hepatic flexure of   colon                                                   	| popv       	| Male   	| 1       	|
| large intestine - rectum                                                                       	| celltypist 	| Female 	| 3       	|
| large intestine - rectum                                                                       	| popv       	| Female 	| 3       	|
| large intestine - sigmoid colon                                                                	| celltypist 	| Female 	| 7       	|
| large intestine - sigmoid colon                                                                	| celltypist 	| Male   	| 8       	|
| large intestine - sigmoid colon                                                                	| popv       	| Female 	| 7       	|
| large intestine - sigmoid colon                                                                	| popv       	| Male   	| 8       	|
| large intestine - transverse colon                                                             	| celltypist 	| Female 	| 3       	|
| large intestine - transverse colon                                                             	| celltypist 	| Male   	| 5       	|
| large intestine - transverse colon                                                             	| popv       	| Female 	| 3       	|
| large intestine - transverse colon                                                             	| popv       	| Male   	| 5       	|
| left kidney - hilum of kidney                                                                  	| azimuth    	| Male   	| 2       	|
| left kidney - kidney capsule                                                                   	| azimuth    	| Female 	| 3       	|
| left kidney - kidney capsule                                                                   	| azimuth    	| Male   	| 2       	|
| left kidney - outer cortex of kidney                                                           	| azimuth    	| Female 	| 17      	|
| left kidney - outer cortex of kidney                                                           	| azimuth    	| Male   	| 19      	|
| left kidney - renal column                                                                     	| azimuth    	| Female 	| 10      	|
| left kidney - renal column                                                                     	| azimuth    	| Male   	| 2       	|
| left kidney - renal papilla                                                                    	| azimuth    	| Female 	| 5       	|
| left kidney - renal pyramid                                                                    	| azimuth    	| Female 	| 37      	|
| left kidney - renal pyramid                                                                    	| azimuth    	| Male   	| 31      	|
| left ureter - Left ureter                                                                      	| azimuth    	| Female 	| 4       	|
| left ureter - Left ureter                                                                      	| azimuth    	| Male   	| 8       	|
| liver - capsule of the liver                                                                   	| celltypist 	| Female 	| 1       	|
| liver - capsule of the liver                                                                   	| celltypist 	| Male   	| 1       	|
| liver - capsule of the liver                                                                   	| popv       	| Female 	| 1       	|
| liver - capsule of the liver                                                                   	| popv       	| Male   	| 1       	|
| liver - diaphragmatic surface of liver                                                         	| celltypist 	| Female 	| 1       	|
| liver - diaphragmatic surface of liver                                                         	| celltypist 	| Male   	| 1       	|
| liver - diaphragmatic surface of liver                                                         	| popv       	| Female 	| 1       	|
| liver - diaphragmatic surface of liver                                                         	| popv       	| Male   	| 1       	|
| liver - gastric impression of liver                                                            	| celltypist 	| Female 	| 1       	|
| liver - gastric impression of liver                                                            	| celltypist 	| Male   	| 1       	|
| liver - gastric impression of liver                                                            	| popv       	| Female 	| 1       	|
| liver - gastric impression of liver                                                            	| popv       	| Male   	| 1       	|
| male reproductive system - Verumontanum                                                        	| popv       	| Male   	| 2       	|
| male reproductive system - apex of   prostate                                                  	| popv       	| Male   	| 2       	|
| male reproductive system - central zone   of prostate                                          	| popv       	| Male   	| 6       	|
| male reproductive system - peripheral   zone of prostate                                       	| popv       	| Male   	| 6       	|
| male reproductive system - seminal   vesicle                                                   	| popv       	| Male   	| 2       	|
| male reproductive system - transition   zone of prostate                                       	| popv       	| Male   	| 2       	|
| pancreas - Neck of pancreas                                                                    	| azimuth    	| Female 	| 1       	|
| pancreas - Neck of pancreas                                                                    	| azimuth    	| Male   	| 1       	|
| pancreas - Neck of pancreas                                                                    	| celltypist 	| Female 	| 1       	|
| pancreas - Neck of pancreas                                                                    	| celltypist 	| Male   	| 1       	|
| pancreas - Neck of pancreas                                                                    	| popv       	| Female 	| 1       	|
| pancreas - Neck of pancreas                                                                    	| popv       	| Male   	| 1       	|
| pancreas - body of pancreas                                                                    	| azimuth    	| Female 	| 1       	|
| pancreas - body of pancreas                                                                    	| azimuth    	| Male   	| 1       	|
| pancreas - body of pancreas                                                                    	| celltypist 	| Female 	| 1       	|
| pancreas - body of pancreas                                                                    	| celltypist 	| Male   	| 1       	|
| pancreas - body of pancreas                                                                    	| popv       	| Female 	| 1       	|
| pancreas - body of pancreas                                                                    	| popv       	| Male   	| 1       	|
| pancreas - head of pancreas                                                                    	| azimuth    	| Female 	| 1       	|
| pancreas - head of pancreas                                                                    	| azimuth    	| Male   	| 1       	|
| pancreas - head of pancreas                                                                    	| celltypist 	| Female 	| 1       	|
| pancreas - head of pancreas                                                                    	| celltypist 	| Male   	| 1       	|
| pancreas - head of pancreas                                                                    	| popv       	| Female 	| 1       	|
| pancreas - head of pancreas                                                                    	| popv       	| Male   	| 1       	|
| pancreas - tail of pancreas                                                                    	| azimuth    	| Female 	| 1       	|
| pancreas - tail of pancreas                                                                    	| azimuth    	| Male   	| 1       	|
| pancreas - tail of pancreas                                                                    	| celltypist 	| Female 	| 1       	|
| pancreas - tail of pancreas                                                                    	| celltypist 	| Male   	| 1       	|
| pancreas - tail of pancreas                                                                    	| popv       	| Female 	| 1       	|
| pancreas - tail of pancreas                                                                    	| popv       	| Male   	| 1       	|
| pancreas - uncinate process of pancreas                                                        	| azimuth    	| Female 	| 1       	|
| pancreas - uncinate process of pancreas                                                        	| azimuth    	| Male   	| 1       	|
| pancreas - uncinate process of pancreas                                                        	| celltypist 	| Female 	| 1       	|
| pancreas - uncinate process of pancreas                                                        	| celltypist 	| Male   	| 1       	|
| pancreas - uncinate process of pancreas                                                        	| popv       	| Female 	| 1       	|
| pancreas - uncinate process of pancreas                                                        	| popv       	| Male   	| 1       	|
| respiratory system - Cartilage of   segmental bronchus                                         	| azimuth    	| Female 	| 1       	|
| respiratory system - Cartilage of   segmental bronchus                                         	| azimuth    	| Male   	| 4       	|
| respiratory system - Cartilage of   segmental bronchus                                         	| celltypist 	| Female 	| 1       	|
| respiratory system - Cartilage of   segmental bronchus                                         	| celltypist 	| Male   	| 4       	|
| respiratory system - Cartilage of   segmental bronchus                                         	| popv       	| Female 	| 1       	|
| respiratory system - Cartilage of   segmental bronchus                                         	| popv       	| Male   	| 4       	|
| respiratory system - Lateral segmental   bronchus                                              	| azimuth    	| Female 	| 1       	|
| respiratory system - Lateral segmental   bronchus                                              	| azimuth    	| Male   	| 2       	|
| respiratory system - Lateral segmental   bronchus                                              	| celltypist 	| Female 	| 1       	|
| respiratory system - Lateral segmental   bronchus                                              	| celltypist 	| Male   	| 2       	|
| respiratory system - Lateral segmental   bronchus                                              	| popv       	| Female 	| 1       	|
| respiratory system - Lateral segmental   bronchus                                              	| popv       	| Male   	| 2       	|
| respiratory system - Left Medial Basal   Bronchopulmonary Segment                              	| azimuth    	| Male   	| 1       	|
| respiratory system - Left Medial Basal   Bronchopulmonary Segment                              	| celltypist 	| Male   	| 1       	|
| respiratory system - Left Medial Basal   Bronchopulmonary Segment                              	| popv       	| Male   	| 1       	|
| respiratory system - Left anterior   segmental bronchus                                        	| azimuth    	| Male   	| 1       	|
| respiratory system - Left anterior   segmental bronchus                                        	| celltypist 	| Male   	| 1       	|
| respiratory system - Left anterior   segmental bronchus                                        	| popv       	| Male   	| 1       	|
| respiratory system - Left apical   segmental bronchus                                          	| azimuth    	| Male   	| 1       	|
| respiratory system - Left apical   segmental bronchus                                          	| celltypist 	| Male   	| 1       	|
| respiratory system - Left apical   segmental bronchus                                          	| popv       	| Male   	| 1       	|
| respiratory system - Left lateral basal   segmental bronchus                                   	| azimuth    	| Male   	| 1       	|
| respiratory system - Left lateral basal   segmental bronchus                                   	| celltypist 	| Male   	| 1       	|
| respiratory system - Left lateral basal   segmental bronchus                                   	| popv       	| Male   	| 1       	|
| respiratory system - Left medial basal   segmental bronchus                                    	| azimuth    	| Male   	| 1       	|
| respiratory system - Left medial basal   segmental bronchus                                    	| celltypist 	| Male   	| 1       	|
| respiratory system - Left medial basal   segmental bronchus                                    	| popv       	| Male   	| 1       	|
| respiratory system - Left posterior basal   segmental bronchus                                 	| azimuth    	| Female 	| 8       	|
| respiratory system - Left posterior basal   segmental bronchus                                 	| azimuth    	| Male   	| 21      	|
| respiratory system - Left posterior basal   segmental bronchus                                 	| celltypist 	| Female 	| 8       	|
| respiratory system - Left posterior basal   segmental bronchus                                 	| celltypist 	| Male   	| 21      	|
| respiratory system - Left posterior basal   segmental bronchus                                 	| popv       	| Female 	| 8       	|
| respiratory system - Left posterior basal   segmental bronchus                                 	| popv       	| Male   	| 21      	|
| respiratory system - Left posterior   bronchopulmonary segment                                 	| azimuth    	| Male   	| 1       	|
| respiratory system - Left posterior   bronchopulmonary segment                                 	| celltypist 	| Male   	| 1       	|
| respiratory system - Left posterior   bronchopulmonary segment                                 	| popv       	| Male   	| 1       	|
| respiratory system - Right Anterior   Bronchopulmonary Segment                                 	| azimuth    	| Female 	| 1       	|
| respiratory system - Right Anterior   Bronchopulmonary Segment                                 	| celltypist 	| Female 	| 1       	|
| respiratory system - Right Anterior   Bronchopulmonary Segment                                 	| popv       	| Female 	| 1       	|
| respiratory system - Right Lateral   Bronchopulmonary Segment                                  	| azimuth    	| Male   	| 3       	|
| respiratory system - Right Lateral   Bronchopulmonary Segment                                  	| celltypist 	| Male   	| 3       	|
| respiratory system - Right Lateral   Bronchopulmonary Segment                                  	| popv       	| Male   	| 3       	|
| respiratory system - Right Medial   Bronchopulmonary Segment                                   	| azimuth    	| Male   	| 8       	|
| respiratory system - Right Medial   Bronchopulmonary Segment                                   	| celltypist 	| Male   	| 8       	|
| respiratory system - Right Medial   Bronchopulmonary Segment                                   	| popv       	| Male   	| 8       	|
| respiratory system - Right Posterior   Basal Bronchopulmonary Segment                          	| azimuth    	| Female 	| 7       	|
| respiratory system - Right Posterior   Basal Bronchopulmonary Segment                          	| azimuth    	| Male   	| 9       	|
| respiratory system - Right Posterior   Basal Bronchopulmonary Segment                          	| celltypist 	| Female 	| 7       	|
| respiratory system - Right Posterior   Basal Bronchopulmonary Segment                          	| celltypist 	| Male   	| 9       	|
| respiratory system - Right Posterior   Basal Bronchopulmonary Segment                          	| popv       	| Female 	| 7       	|
| respiratory system - Right Posterior   Basal Bronchopulmonary Segment                          	| popv       	| Male   	| 9       	|
| respiratory system - Right anterior basal   bronchopulmonary segment                           	| azimuth    	| Male   	| 1       	|
| respiratory system - Right anterior basal   bronchopulmonary segment                           	| celltypist 	| Male   	| 1       	|
| respiratory system - Right anterior basal   bronchopulmonary segment                           	| popv       	| Male   	| 1       	|
| respiratory system - Right superior   segmental bronchus                                       	| azimuth    	| Male   	| 1       	|
| respiratory system - Right superior   segmental bronchus                                       	| celltypist 	| Male   	| 1       	|
| respiratory system - Right superior   segmental bronchus                                       	| popv       	| Male   	| 1       	|
| respiratory system - Superior lingular   bronchopulmonary segment                              	| azimuth    	| Female 	| 1       	|
| respiratory system - Superior lingular   bronchopulmonary segment                              	| celltypist 	| Female 	| 1       	|
| respiratory system - Superior lingular   bronchopulmonary segment                              	| popv       	| Female 	| 1       	|
| respiratory system - left Lateral Basal   Bronchopulmonary Segment                             	| azimuth    	| Male   	| 1       	|
| respiratory system - left Lateral Basal   Bronchopulmonary Segment                             	| celltypist 	| Male   	| 1       	|
| respiratory system - left Lateral Basal   Bronchopulmonary Segment                             	| popv       	| Male   	| 1       	|
| respiratory system - left anterior basal   bronchopulmonary segment                            	| azimuth    	| Male   	| 1       	|
| respiratory system - left anterior basal   bronchopulmonary segment                            	| celltypist 	| Male   	| 1       	|
| respiratory system - left anterior basal   bronchopulmonary segment                            	| popv       	| Male   	| 1       	|
| right kidney - kidney capsule                                                                  	| azimuth    	| Female 	| 2       	|
| right kidney - outer cortex of kidney                                                          	| azimuth    	| Female 	| 5       	|
| right kidney - outer cortex of kidney                                                          	| azimuth    	| Male   	| 75      	|
| right kidney - renal papilla                                                                   	| azimuth    	| Female 	| 2       	|
| right kidney - renal papilla                                                                   	| azimuth    	| Male   	| 2       	|
| right kidney - renal pyramid                                                                   	| azimuth    	| Female 	| 13      	|
| right kidney - renal pyramid                                                                   	| azimuth    	| Male   	| 4       	|
| right ureter - Right ureter                                                                    	| azimuth    	| Female 	| 1       	|
| right ureter - Right ureter                                                                    	| azimuth    	| Male   	| 2       	|
| skin of body - skin                                                                            	| celltypist 	| Female 	| 1       	|
| skin of body - skin                                                                            	| celltypist 	| Male   	| 6       	|
| skin of body - skin                                                                            	| popv       	| Female 	| 1       	|
| skin of body - skin                                                                            	| popv       	| Male   	| 6       	|
| small intestine - ascending part of   duodenum                                                 	| celltypist 	| Female 	| 3       	|
| small intestine - ascending part of   duodenum                                                 	| celltypist 	| Male   	| 8       	|
| small intestine - ascending part of   duodenum                                                 	| popv       	| Female 	| 3       	|
| small intestine - ascending part of   duodenum                                                 	| popv       	| Male   	| 8       	|
| small intestine - descending part of   duodenum                                                	| celltypist 	| Female 	| 4       	|
| small intestine - descending part of   duodenum                                                	| celltypist 	| Male   	| 7       	|
| small intestine - descending part of   duodenum                                                	| popv       	| Female 	| 4       	|
| small intestine - descending part of   duodenum                                                	| popv       	| Male   	| 7       	|
| small intestine - distal part of ileum                                                         	| celltypist 	| Female 	| 3       	|
| small intestine - distal part of ileum                                                         	| celltypist 	| Male   	| 7       	|
| small intestine - distal part of ileum                                                         	| popv       	| Female 	| 3       	|
| small intestine - distal part of ileum                                                         	| popv       	| Male   	| 7       	|
| small intestine - duodenal ampulla                                                             	| celltypist 	| Female 	| 2       	|
| small intestine - duodenal ampulla                                                             	| popv       	| Female 	| 2       	|
| small intestine - horizontal part of   duodenum                                                	| celltypist 	| Female 	| 3       	|
| small intestine - horizontal part of   duodenum                                                	| celltypist 	| Male   	| 7       	|
| small intestine - horizontal part of   duodenum                                                	| popv       	| Female 	| 3       	|
| small intestine - horizontal part of   duodenum                                                	| popv       	| Male   	| 7       	|
| small intestine - ileum                                                                        	| celltypist 	| Female 	| 5       	|
| small intestine - ileum                                                                        	| celltypist 	| Male   	| 1       	|
| small intestine - ileum                                                                        	| popv       	| Female 	| 5       	|
| small intestine - ileum                                                                        	| popv       	| Male   	| 1       	|
| small intestine - jejunum                                                                      	| celltypist 	| Female 	| 4       	|
| small intestine - jejunum                                                                      	| celltypist 	| Male   	| 8       	|
| small intestine - jejunum                                                                      	| popv       	| Female 	| 4       	|
| small intestine - jejunum                                                                      	| popv       	| Male   	| 8       	|
| small intestine - superior part of   duodenum                                                  	| celltypist 	| Female 	| 2       	|
| small intestine - superior part of   duodenum                                                  	| celltypist 	| Male   	| 1       	|
| small intestine - superior part of   duodenum                                                  	| popv       	| Female 	| 2       	|
| small intestine - superior part of   duodenum                                                  	| popv       	| Male   	| 1       	|
| spleen - diaphragmatic surface of spleen                                                       	| popv       	| Male   	| 6       	|
| spleen - hilum of spleen                                                                       	| popv       	| Female 	| 2       	|
| spleen - hilum of spleen                                                                       	| popv       	| Male   	| 2       	|
| thymus - left thymus lobe                                                                      	| popv       	| Female 	| 2       	|
| thymus - left thymus lobe                                                                      	| popv       	| Male   	| 2       	|
| thymus - right thymus lobe                                                                     	| popv       	| Female 	| 2       	|
| thymus - right thymus lobe                                                                     	| popv       	| Male   	| 2       	|
| urinary bladder - fundus of urinary   bladder                                                  	| popv       	| Female 	| 2       	|
| urinary bladder - fundus of urinary   bladder                                                  	| popv       	| Male   	| 5       	|
| urinary bladder - trigone of urinary   bladder                                                 	| popv       	| Male   	| 4       	|