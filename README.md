# Looker 2.0: _The SQL_

This project's main purpose is to research, design, and explore better
data modeling practices within our Looker implementation.

Eventually, we will finalize a design and implementation strategy to
perform a migration in tandem with the creation of many of the new
dbt models.

### Benefits of Improved LookML Infrastructure

- Faster queries 🏎️
- Lower costs 💸
- More robust data definitions 📖
- Replicable structure and processes 🏭

### Main Areas of Improvement

- [Organization of lookML folders]
-- Improving usability for LookML Developers
- Separate models per company / business unit
-- Reducing size of models
-- Increasing specificity of models
-- Improving permissions/access capabilities to certain models
- Refining Explores
-- Utilization of [extended views]
-- Cleaner implemention of PDTs
-- Significantly reducing size of explores (<10 joins)
- Integration of newest dbt models
-- Elimination of PDTs where applicable
- Miscellaneous
-- Establishing a clear naming convention
-- [LookML dashboards]? Or just user dashboards
-- Adding more guardrails to development to ensure future-proofing
-- ... but not so many guardrails that it hinders productivity

## Project Roadmap
1. Initial Resarch ✅
2. Proof of Concept ✅
3. Brainstorm
4. Development
5. Validation
6. Implementation

### [Additional Resources]

[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen.)

   [extended views]: <https://medium.com/@dataplatr/mastering-large-projects-in-google-looker-structured-model-creation-and-management-f284327cec18>
   [Organization of lookML folders]: <https://medium.com/slateco-blog/how-to-structure-your-lookml-project-5682d178a3ca>
   [LookML dashboards]: <https://cloud.google.com/looker/docs/building-lookml-dashboards>
   [Additional Resources]: <https://www.scdata.co/looker-tips>
