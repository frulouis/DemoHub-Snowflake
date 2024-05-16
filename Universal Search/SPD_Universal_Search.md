# Snowflake Universal Search<a id="snowflake-universal-search"></a>

Snowflake, renowned for its cloud-based data warehousing and analytics platform, continually innovates to empower its users. A shining example of this commitment is **Universal Search**, a tool that revolutionizes how we discover and interact with data within Snowflake.


### Beyond Basic Search<a id="beyond-basic-search"></a>

Traditional search within Snowflake, while functional, has been limited to string-based matching. This meant that if you searched for "customer," you wouldn't find results for "buyer" or "client," even though they are semantically related. Universal Search breaks this barrier.


### The Semantic Advantage<a id="the-semantic-advantage"></a>

By harnessing the capabilities of Large Language Models (LLMs), Universal Search understands the meaning behind your queries, not just the keywords. This opens up a new world of possibilities:

- **Semantic Relationships:** A search for "customer" will now yield results like "buyer," "client," and other synonyms.

- **Natural Language Queries:** You can search using phrases like "sales opportunities that are likely to close" or "which opportunities came from partner referrals," and Universal Search will intelligently interpret your intent.


### Demo: Unveiling the Magic<a id="demo-unveiling-the-magic"></a>

To illustrate the power of Universal Search, let's explore a scenario using the sample data model provided in the companion GitHub repository:[ **https://github.com/frulouis/DemoHub-Snowflake-Pocket-Book-SPD.git**](https://github.com/frulouis/DemoHub-Snowflake-Pocket-Book-SPD.git)

![SalesDB Data Model](https://i.ibb.co/5KFCp2j/Sample-Image.jpg)

The provided data model includes four tables: `Customer`, `Buyer`, `Client`, and `Opportunities`. It incorporates comments and tags to enhance search capabilities and security. Additionally, functions, stored procedures, and views are provided to demonstrate how Universal Search can be used for deeper analysis.

Try these searches and observe the results:

- **Search Term:** "Customer"

  - **Universal Search Results:** Include "buyer," "client," and other related terms.

- **Search Term:** "Zip Code"

  - **Universal Search Results:** Include "postal code."

- **Search Term:** "Address"

  - **Universal Search Results:** Include "home location."

- **Search Term:** "Agreement" or "Addendum"

  - **Universal Search Results:** Include "contract."

- **Search Term:** "Leads"

  - **Universal Search Results:** Include "opportunities."

- **Natural Language Queries:** "sales opportunities that are likely to close" or "which opportunities came from partner referrals"


### Secure Data Discovery with Snowflake Universal Search<a id="secure-data-discovery-with-snowflake-universal-search"></a>

A crucial aspect of Universal Search is its seamless integration with Snowflake's robust security model. By adhering to Role-Based Access Controls (RBAC), Universal Search ensures that sensitive data remains protected and accessible only to authorized users.


#### Demonstrating RBAC in Action<a id="demonstrating-rbac-in-action"></a>

Consider two roles: `SalesRep` and `SalesManager`. The `SalesRep` can only query the `Customer` table, while the `SalesManager` has broader access. A `SalesRep` searching for "all opportunities" will see only customer information, while a `SalesManager` would also see opportunities from the `Opportunities` table.


#### Key Takeaways<a id="key-takeaways"></a>

- Universal Search respects existing security measures, working within the RBAC framework.

- This ensures that sensitive data is not inadvertently exposed.

- Universal Search seamlessly adapts to granular role-based permissions.

- Object tagging (e.g., "Confidential") can be used to further control the visibility of Snowflake objects.


### Beyond Security: Additional Features and Considerations<a id="beyond-security-additional-features-and-considerations"></a>

- **Shared Objects:** Easily discoverable via Universal Search.

- **Indexing:** Near-instantaneous, but new objects may take a few hours to appear in results.

- **Cost:** Currently free within the Snowsight interface.

- **Language:** Optimized for English search terms.

- **Logging:** Search history logging is planned for the future.


### Under the Hood: The Technology<a id="under-the-hood-the-technology"></a>

Universal Search indexes your Snowflake catalog, Marketplace listings, and documentation. It combines traditional information retrieval with machine learning (including a non-generative LLM) without using customer data for LLM training.


### The Road Ahead & Integration with Data Catalogs<a id="the-road-ahead--integration-with-data-catalogs"></a>

Snowflake has an ambitious roadmap for Universal Search, with upcoming features like filtering by PII tags, object previews, and API access.

While not a replacement for enterprise data catalogs, Universal Search complements them. It acts as a powerful search engine _within_ Snowflake, while the catalog provides broader visibility into enterprise data assets outside of Snowflake.


### Embracing the Future of Data Discovery<a id="embracing-the-future-of-data-discovery"></a>

Universal Search represents a major leap forward in data discovery within Snowflake. Its semantic understanding and integration with security features make it an invaluable tool for data-driven organizations.


### Resources<a id="resources"></a>

- Search Snowflake objects and resources with Universal Search:[ https://docs.snowflake.com/user-guide/ui-snowsight-universal-search](https://docs.snowflake.com/user-guide/ui-snowsight-universal-search)

- DemoHub Universal code repository:[ **https://github.com/frulouis/DemoHub-Snowflake-Pocket-Book-SPD.git**](https://github.com/frulouis/DemoHub-Snowflake-Pocket-Book-SPD.git)
