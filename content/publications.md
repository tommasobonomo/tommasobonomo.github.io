+++
title = "Publications"
+++

## Exploring the Dissociated Nucleus Phenomenon in Semantic Role Labeling
**Tommaso Bonomo, Simone Conia, Roberto Navigli**  
*Tenth Italian Conference on Computational Linguistics (CLiC-it 2024)*

Dependency-based Semantic Role Labeling (SRL) is bound to dependency parsing, as the arguments of a predicate are identified through the token that heads the dependency relation subtree of the argument span. However, dependency-based SRL corpora are susceptible to the dissociated nucleus problem: when a subclause’s semantic and structural cores are two separate words, the dependency tree chooses the structural token as the head of the subtree, coercing the SRL annotation into making the same choice. This leads to undesirable consequences: when directly using the output of a dependency-based SRL method in downstream tasks it is useful to work with the token representing the semantic core of a subclause, not the structural core. In this paper, we carry out a linguistically-driven investigation on the dissociated nucleus problem in dependency-based SRL and propose a novel algorithm that aligns predicate-argument structures to the syntactic structures from Universal Dependencies to select the semantic core of an argument. Our analysis shows that dissociated nuclei appear more often than one might expect, and that our novel algorithm greatly increases the richness of the semantic information in dependency-based SRL. We release the software to reproduce our experiments at [github.com/SapienzaNLP/semdepalign](https://github.com/SapienzaNLP/semdepalign).
<div class="paper-link">📄 <a href="https://ceur-ws.org/Vol-3878/11_main_long.pdf">Read Paper</a></div>


