<?xml version="1.0" encoding="UTF-8" ?>
<!--
 Licensed to the Apache Software Foundation (ASF) under one or more
 contributor license agreements.  See the NOTICE file distributed with
 this work for additional information regarding copyright ownership.
 The ASF licenses this file to You under the Apache License, Version 2.0
 (the "License"); you may not use this file except in compliance with
 the License.  You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
-->

<!--

 This example schema is the recommended starting point for users.
 It should be kept correct and concise, usable out-of-the-box.


 For more information, on how to customize this file, please see
 http://lucene.apache.org/solr/guide/documents-fields-and-schema-design.html

 PERFORMANCE NOTE: this schema includes many optional features and should not
 be used for benchmarking.  To improve performance one could
  - set stored="false" for all fields possible (esp large fields) when you
    only need to search on the field but don't need to return the original
    value.
  - set indexed="false" if you don't need to search on the field, but only
    return the field as a result of searching on other indexed fields.
  - remove all unneeded copyField statements
  - for best index size and searching performance, set "index" to false
    for all general text fields, use copyField to copy them to the
    catchall "text" field, and use that for searching.
-->

<schema name="default-config" version="1.7">
    <!-- attribute "name" is the name of this schema and is only used for display purposes.
       version="x.y" is Solr's version number for the schema syntax and 
       semantics.  It should not normally be changed by applications.

       1.0: multiValued attribute did not exist, all fields are multiValued 
            by nature
       1.1: multiValued attribute introduced, false by default 
       1.2: omitTermFreqAndPositions attribute introduced, true by default 
            except for text fields.
       1.3: removed optional field compress feature
       1.4: autoGeneratePhraseQueries attribute introduced to drive QueryParser
            behavior when a single string produces multiple tokens.  Defaults 
            to off for version >= 1.4
       1.5: omitNorms defaults to true for primitive field types 
            (int, float, boolean, string...)
       1.6: useDocValuesAsStored defaults to true.
    -->

    <!-- Valid attributes for fields:
     name: mandatory - the name for the field
     type: mandatory - the name of a field type from the 
       fieldTypes section
     indexed: true if this field should be indexed (searchable or sortable)
     stored: true if this field should be retrievable
     docValues: true if this field should have doc values. Doc Values is
       recommended (required, if you are using *Point fields) for faceting,
       grouping, sorting and function queries. Doc Values will make the index
       faster to load, more NRT-friendly and more memory-efficient. 
       They are currently only supported by StrField, UUIDField, all 
       *PointFields, and depending on the field type, they might require
       the field to be single-valued, be required or have a default value
       (check the documentation of the field type you're interested in for
       more information)
     multiValued: true if this field may contain multiple values per document
     omitNorms: (expert) set to true to omit the norms associated with
       this field (this disables length normalization and index-time
       boosting for the field, and saves some memory).  Only full-text
       fields or fields that need an index-time boost need norms.
       Norms are omitted for primitive (non-analyzed) types by default.
     termVectors: [false] set to true to store the term vector for a
       given field.
       When using MoreLikeThis, fields used for similarity should be
       stored for best performance.
     termPositions: Store position information with the term vector.  
       This will increase storage costs.
     termOffsets: Store offset information with the term vector. This 
       will increase storage costs.
     required: The field is required.  It will throw an error if the
       value does not exist
     default: a value that should be used if no value is specified
       when adding a document.
    -->

    <!-- field names should consist of alphanumeric or underscore characters only and
      not start with a digit.  This is not currently strictly enforced,
      but other field names will not have first class support from all components
      and back compatibility is not guaranteed.  Names with both leading and
      trailing underscores (e.g. _version_) are reserved.
    -->

    <!-- In this _default configset, only four fields are pre-declared:
         id, _version_, and _text_ and _root_. All other fields will be type guessed and added via the
         "add-unknown-fields-to-the-schema" update request processor chain declared in solrconfig.xml.
         
         Note that many dynamic fields are also defined - you can use them to specify a 
         field's type via field naming conventions - see below.
  
         WARNING: The _text_ catch-all field will significantly increase your index size.
         If you don't need it, consider removing it and the corresponding copyField directive."
    -->

    <field name="id" type="string" indexed="true" stored="true" required="true" multiValued="false" />
    <!-- docValues are enabled by default for long type so we don't need to index the version field  -->
    <field name="_version_" type="plong" indexed="false" stored="false"/>
    <field name="_root_" type="string" indexed="true" stored="false" docValues="false" />

    
     
    
    
<!-- Start: Dataverse-specific -->    
    
    <!-- catchall field, containing all other searchable text fields (implemented
        via copyField further on in this schema  -->
    <!-- Dataverse solr 7.3.0: for some reason the old text wasn't working so switched to _text_ for copyfields -->
        <!--<field name="text" type="text_general" indexed="true" stored="false" multiValued="true"/>-->
        <field name="_text_" type="text_general" indexed="true" stored="false" multiValued="true"/>
    <!-- catchall text field that indexes tokens both normally and in reverse for efficient
        leading wildcard queries. -->
    <field name="text_rev" type="text_general_rev" indexed="true" stored="false" multiValued="true"/>    
    <field name="name" type="text_en" indexed="true" stored="true"/> 








    <field name="definitionPointDocId" type="string" stored="true" indexed="true" multiValued="false"/>
    <field name="definitionPointDvObjectId" type="string" stored="true" indexed="true" multiValued="false"/>
    <field name="discoverableBy" type="string" stored="true" indexed="true" multiValued="true"/>

    <field name="dvObjectType" type="string" stored="true" indexed="true" multiValued="false"/>
    <field name="metadataSource" type="string" stored="true" indexed="true" multiValued="false"/>
    <field name="isHarvested" type="boolean" stored="true" indexed="true" multiValued="false"/>
    <field name="fileDeleted" type="boolean" stored="true" indexed="true" multiValued="false"/>

    <field name="dvName" type="text_en" stored="true" indexed="true" multiValued="false"/>
    <field name="dvAlias" type="text_en" stored="true" indexed="true" multiValued="false"/>
    <field name="dvAffiliation" type="text_en" stored="true" indexed="true" multiValued="false"/>
    <field name="dvDescription" type="text_en" stored="true" indexed="true" multiValued="false"/>

    <field name="dvCategory" type="string" stored="true" indexed="true" multiValued="false"/>
    <field name="categoryOfDataverse" type="string" stored="true" indexed="true" multiValued="false"/>
    <field name="identifierOfDataverse" type="string" stored="true" indexed="true" multiValued="false"/>
    
    <field name="publicationDate" type="string" stored="true" indexed="true" multiValued="false"/>
    <field name="dsPublicationDate" type="string" stored="true" indexed="true" multiValued="false"/>

    <field name="dvSubject" type="string" stored="true" indexed="true" multiValued="true"/>

    <field name="publicationStatus" type="string" stored="true" indexed="true" multiValued="true"/>
    <field name="externalStatus" type="string" stored="true" indexed="true" multiValued="false"/>
    <field name="embargoEndDate" type="long" stored="true" indexed="true" multiValued="false"/>
    
    <field name="subtreePaths" type="string" stored="true" indexed="true" multiValued="true"/>

    <field name="fileName" type="text_en" stored="true" indexed="true" multiValued="true"/>
    <field name="fileType" type="text_en" stored="true" indexed="true" multiValued="true"/>
    <field name="fileNameWithoutExtension" type="text_en" stored="true" indexed="true" multiValued="true"/>
    <field name="variableName" type="text_en" stored="true" indexed="true" multiValued="true"/>
    <field name="variableLabel" type="text_en" stored="true" indexed="true" multiValued="true"/>

    <field name="literalQuestion" type="text_en" stored="true" indexed="true" multiValued="true"/>
    <field name="interviewInstructions" type="text_en" stored="true" indexed="true" multiValued="true"/>
    <field name="postQuestion" type="text_en" stored="true" indexed="true" multiValued="true"/>
    <field name="variableUniverse" type="text_en" stored="true" indexed="true" multiValued="true"/>
    <field name="variableNotes" type="text_en" stored="true" indexed="true" multiValued="true"/>

    <field name="fileDescription" type="text_en" stored="true" indexed="true" multiValued="false"/>

    <field name="fileTypeGroupFacet" type="string" stored="true" indexed="true" multiValued="false"/>
    <field name="fileTypeDisplay" type="string" stored="true" indexed="true" multiValued="false"/>
    <field name="fileTag" type="string" stored="true" indexed="true" multiValued="true"/>
    <field name="fileTags" type="text_en" stored="true" indexed="true" multiValued="true"/>
    <field name="tabularDataTag" type="string" stored="true" indexed="true" multiValued="true"/>
    <field name="fileAccess" type="string" stored="true" indexed="true" multiValued="true"/>

    <!-- Added for Dataverse 4.0 alpha 1: static "parent" fields not copied to "catchall" field https://redmine.hmdc.harvard.edu/issues/3603  -->
    <!-- We index parentid and parentname as a debugging aid in case we want to match on it with an explict query like curl 'http://localhost:8983/solr/collection1/select?rows=100&wt=json&indent=true&q=parentId%3A42' or curl 'http://localhost:8983/solr/collection1/select?rows=100&wt=json&indent=true&q=parentName%3Abirds' -->
    <!-- TODO: store parentid as a long instead of a string  -->
    <field name="parentId" type="string" stored="true" indexed="true" multiValued="false"/>
    <field name="parentIdentifier" type="string" stored="true" indexed="true" multiValued="false"/>
    <field name="parentName" type="string" stored="true" indexed="false" multiValued="false"/>
    <field name="parentCitation" type="string" stored="true" indexed="false" multiValued="false"/>
    <field name="citation" type="string" stored="true" indexed="false" multiValued="false"/>
    <field name="citationHtml" type="string" stored="true" indexed="false" multiValued="false"/>
    <field name="identifier" type="string" stored="true" indexed="true" multiValued="false"/>
    <field name="persistentUrl" type="string" stored="true" indexed="false" multiValued="false"/>
    <field name="unf" type="string" stored="true" indexed="true" multiValued="false"/>
    <field name="fileSizeInBytes" type="long" stored="true" indexed="true" multiValued="false"/>
    <field name="fileMd5" type="string" stored="true" indexed="true" multiValued="false"/>
    <field name="fileChecksumType" type="string" stored="true" indexed="true" multiValued="false"/>
    <field name="fileChecksumValue" type="string" stored="true" indexed="true" multiValued="false"/>
    <field name="fileContentType" type="string" stored="true" indexed="true" multiValued="false"/>
    <field name="deaccessionReason" type="string" stored="true" indexed="false" multiValued="false"/>

    <!-- Added for Dataverse 4.0 alpha 1. This is a required field so we don't have to go to the database to get the database id of the entity. On cards we use the id in links -->
    <field name="entityId" type="long" stored="true" indexed="true" multiValued="false"/>

    <field name="datasetVersionId" type="long" stored="true" indexed="true" multiValued="false"/>

    <!-- Added for Dataverse 4.0 alpha 1 to sort by name  -->
    <!-- https://redmine.hmdc.harvard.edu/issues/3482 -->
    <!-- 'Sorting can be done on the "score" of the document, or on any multiValued="false" indexed="true" field provided that field is either non-tokenized (ie: has no Analyzer) or uses an Analyzer that only produces a single Term (ie: uses the KeywordTokenizer)' http://wiki.apache.org/solr/CommonQueryParameters#sort -->
    <!-- http://stackoverflow.com/questions/13360706/solr-4-0-alphabetical-sorting-trouble/13361226#13361226 -->
    <field name="nameSort" type="alphaOnlySort" indexed="true" stored="true"/>

    <field name="dateSort" type="date" indexed="true" stored="true"/>

    <!-- Added for Dataverse 4.0: release date https://redmine.hmdc.harvard.edu/issues/3592 -->
    <field name="releasedate" type="int" indexed="true" stored="true"/>

    <!-- Added for Dataverse 4.0: do we want a description field that applies to dataverses, datasets, and files? https://redmine.hmdc.harvard.edu/issues/3745 -->
    <field name="description" type="text_en" multiValued="false" stored="true" indexed="true"/>

    <field name="dsPersistentId" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="filePersistentId" type="text_en" multiValued="false" stored="true" indexed="true"/>
    
    <!--
        METADATA SCHEMA FIELDS
        Now following: any fields generated from the metadata schemas loaded into Dataverse.
        
        Note: You can retrieve a list of the following fields from a specific API endpoint of your Dataverse
              installation, available at "http://<your Dataverse host>/api/admin/index/solr/schema".
              See also https://guides.dataverse.org/en/latest/admin/metadatacustomization.html#updating-the-solr-schema
              
        Note: Please see https://guides.dataverse.org/en/latest/admin/metadatacustomization.html for advice on
              how to create your own metadata schemas.
        
        WARNING: Do not remove the following include guards if you intend to use the neat helper scripts we provide.
    -->
    <!-- SCHEMA-FIELDS::BEGIN -->
    <field name="accessToSources" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="actionsToMinimizeLoss" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="alternativeTitle" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="alternativeURL" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="astroFacility" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="astroInstrument" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="astroObject" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="astroType" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="author" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="authorAffiliation" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="authorIdentifier" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="authorIdentifierScheme" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="authorName" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="characteristicOfSources" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="city" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="cleaningOperations" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="collectionMode" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="collectorTraining" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="contributor" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="contributorName" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="contributorType" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="controlOperations" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="country" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="coverage.Depth" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="coverage.ObjectCount" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="coverage.ObjectDensity" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="coverage.Polarization" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="coverage.Redshift.MaximumValue" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="coverage.Redshift.MinimumValue" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="coverage.RedshiftValue" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="coverage.SkyFraction" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="coverage.Spatial" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="coverage.Spectral.Bandpass" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="coverage.Spectral.CentralWavelength" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="coverage.Spectral.MaximumWavelength" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="coverage.Spectral.MinimumWavelength" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="coverage.Spectral.Wavelength" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="coverage.Temporal" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="coverage.Temporal.StartTime" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="coverage.Temporal.StopTime" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="dataCollectionSituation" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="dataCollector" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="dataSources" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="datasetContact" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="datasetContactAffiliation" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="datasetContactEmail" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="datasetContactName" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="datasetLevelErrorNotes" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="dateOfCollection" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="dateOfCollectionEnd" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="dateOfCollectionStart" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="dateOfDeposit" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="depositor" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="deviationsFromSampleDesign" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="distributionDate" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="distributor" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="distributorAbbreviation" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="distributorAffiliation" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="distributorLogoURL" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="distributorName" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="distributorURL" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="dsDescription" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="dsDescriptionDate" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="dsDescriptionValue" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="eastLongitude" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="frequencyOfDataCollection" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="geographicBoundingBox" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="geographicCoverage" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="geographicUnit" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="grantNumber" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="grantNumberAgency" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="grantNumberValue" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="journalArticleType" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="journalIssue" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="journalPubDate" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="journalVolume" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="journalVolumeIssue" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="keyword" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="keywordValue" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="keywordVocabulary" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="keywordVocabularyURI" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="kindOfData" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="language" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="northLongitude" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="notesText" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="originOfSources" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="otherDataAppraisal" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="otherGeographicCoverage" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="otherId" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="otherIdAgency" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="otherIdValue" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="otherReferences" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="producer" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="producerAbbreviation" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="producerAffiliation" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="producerLogoURL" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="producerName" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="producerURL" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="productionDate" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="productionPlace" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="publication" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="publicationCitation" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="publicationIDNumber" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="publicationIDType" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="publicationURL" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="redshiftType" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="relatedDatasets" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="relatedMaterial" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="researchInstrument" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="resolution.Redshift" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="resolution.Spatial" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="resolution.Spectral" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="resolution.Temporal" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="responseRate" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="samplingErrorEstimates" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="samplingProcedure" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="series" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="seriesInformation" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="seriesName" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="socialScienceNotes" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="socialScienceNotesSubject" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="socialScienceNotesText" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="socialScienceNotesType" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="software" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="softwareName" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="softwareVersion" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="southLongitude" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="state" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="studyAssayCellType" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="studyAssayMeasurementType" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="studyAssayOrganism" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="studyAssayOtherMeasurmentType" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="studyAssayOtherOrganism" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="studyAssayOtherPlatform" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="studyAssayOtherTechnologyType" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="studyAssayPlatform" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="studyAssayTechnologyType" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="studyDesignType" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="studyFactorType" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="studyOtherDesignType" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="studyOtherFactorType" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="subject" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="subtitle" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="targetSampleActualSize" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="targetSampleSize" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="targetSampleSizeFormula" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="timeMethod" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="timePeriodCovered" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="timePeriodCoveredEnd" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="timePeriodCoveredStart" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="title" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="topicClassValue" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="topicClassVocab" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="topicClassVocabURI" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="topicClassification" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="unitOfAnalysis" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="universe" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="weighting" type="text_en" multiValued="false" stored="true" indexed="true"/>
    <field name="westLongitude" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="workflowURI" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="variableVocabularyURI" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="variableDefinition" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="variableTrefwoord" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="matchedKeyword" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="elsstVarLabel1" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="elsstVarLabel2" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="elsstVarLabel3" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="elsstVarUri2" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="elsstVarUri1" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="elsstVarUri3" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="conceptVariableName" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="conceptVariableDefinition" type="text_en" multiValued="true" stored="true" indexed="true"/>    
    <field name="conceptVariableID" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="conceptVariableObjecttype" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="conceptVariableValidFrom" type="text_en" multiValued="true" stored="true" indexed="true"/>    
    <field name="conceptVariableVersion" type="text_en" multiValued="true" stored="true" indexed="true"/>    
    <field name="conceptVariableVersionResponsibility" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="conceptVariableGroeppad" type="text_en" multiValued="true" stored="true" indexed="true"/>    
    <field name="conceptVariableThema" type="text_en" multiValued="true" stored="true" indexed="true"/>    
    <field name="conceptVariableWaardestelselnaam" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="variableId" type="text_en" multiValued="true" stored="true" indexed="true"/>    
    <field name="variableProcessingInstruction" type="text_en" multiValued="true" stored="true" indexed="true"/>    
    <field name="variableDataType" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="variableVolgnummer" type="text_en" multiValued="true" stored="true" indexed="true"/>    
    <field name="providerName" type="text_en" multiValued="true" stored="true" indexed="true"/>
    <field name="NaamInDscCatalogus" type="text_en" multiValued="true" stored="true" indexed="true"/>    
    <field name="UniekeNaam" type="text_en" multiValued="true" stored="true" indexed="true"/>        
    <field name="Eigenaar" type="text_en" multiValued="true" stored="true" indexed="true"/>    
    <field name="GeldigVanaf" type="text_en" multiValued="true" stored="true" indexed="true"/>        
    <field name="GeldigTot" type="text_en" multiValued="true" stored="true" indexed="true"/>    
    <field name="Versie" type="text_en" multiValued="true" stored="true" indexed="true"/>        

    <!-- SCHEMA-FIELDS::END -->

    <copyField source="description" dest="_text_" maxChars="3000"/>

    <!-- Added for Dataverse 4.0 Beta: make variable names and labels searchable in basic search https://redmine.hmdc.harvard.edu/issues/3945 -->
    <copyField source="variableName" dest="_text_" maxChars="3000"/>
    <copyField source="variableLabel" dest="_text_" maxChars="3000"/>
    <!-- Added variable level metadata that can be updated from DCT -->
    <copyField source="literalQuestion" dest="_text_" maxChars="3000"/>
    <copyField source="interviewInstructions" dest="_text_" maxChars="3000"/>
    <copyField source="postQuestion" dest="_text_" maxChars="3000"/>
    <copyField source="variableUniverse" dest="_text_" maxChars="3000"/>
    <copyField source="variableNotes" dest="_text_" maxChars="3000"/>
    <!-- Make dataverse subject and affiliation searchable from basic search: https://github.com/IQSS/dataverse/issues/1431 -->
    <copyField source="dvSubject" dest="_text_" maxChars="3000"/>
    <copyField source="dvAlias" dest="_text_" maxChars="3000"/>
    <copyField source="dvAffiliation" dest="_text_" maxChars="3000"/>
    <copyField source="dsPersistentId" dest="_text_" maxChars="3000"/>
    <!-- copyField commands copy one field to another at the time a document
        is added to the index.  It's used either to index the same field differently,
        or to add multiple fields to the same field for easier/faster searching.  -->

    <!-- <copyField source="cat" dest="_text_"/> -->
    <!-- Dataverse 4.0: we want the "name" field in the "catchall"  -->
    <copyField source="name" dest="_text_"/>
    <!-- Dataverse 4.0: we want the "filetype_en" and "filename_without_extension_en" field in the "catchall" per https://redmine.hmdc.harvard.edu/issues/3848  -->
    <copyField source="fileType" dest="_text_"/>
    <copyField source="fileNameWithoutExtension" dest="_text_"/>
    <!-- <copyField source="manu" dest="_text_"/> -->
    <!-- <copyField source="features" dest="_text_"/> -->
    <!-- <copyField source="includes" dest="_text_"/> -->
    <!-- <copyField source="manu" dest="manu_exact"/> -->

    <!-- Copy the price into a currency enabled field (default USD) -->
    <!-- <copyField source="price" dest="price_c"/> -->

    <!-- Text fields from SolrCell to search by default in our catch-all field -->
    <!-- <copyField source="title" dest="_text_"/> -->
    <!-- <copyField source="author" dest="_text_"/> -->
    <!-- <copyField source="description" dest="_text_"/> -->
    <!-- <copyField source="keywords" dest="_text_"/> -->
    <!-- <copyField source="content" dest="_text_"/> -->
    <!-- <copyField source="content_type" dest="_text_"/> -->
    <!-- <copyField source="resourcename" dest="_text_"/> -->
    <!-- <copyField source="url" dest="_text_"/> -->

    <!-- Create a string version of author for faceting -->
    <!-- <copyField source="author" dest="author_s"/> -->

    <!-- Above, multiple source fields are copied to the [text] field. 
        Another way to map multiple source fields to the same 
        destination field is to use the dynamic field syntax. 
        copyField also supports a maxChars to copy setting.  -->

    <!-- <copyField source="*_t" dest="_text_" maxChars="3000"/> -->

    <!-- Added for Dataverse 4.0 alpha 1 for dynamic datasetfields (but later removed once we have copyField for each field  -->
    <!-- https://redmine.hmdc.harvard.edu/issues/3586 -->
    <!-- <copyField source="*_s" dest="_text_" maxChars="3000"/> -->
    <!-- <copyField source="*_ss" dest="_text_" maxChars="3000"/> -->
    <!-- <copyField source="*_i" dest="_text_" maxChars="3000"/> -->
    
    <!--
        METADATA SCHEMA FIELDS
        Now following: copyFields to copy the contents of the metadata fields above to a
        catch-all textfield necessary for searching in Dataverse.
        
        Note: You can retrieve a list of the following fields from a specific API endpoint of your Dataverse
              installation, available at "http://<your Dataverse host>/api/admin/index/solr/schema".
              See also https://guides.dataverse.org/en/latest/admin/metadatacustomization.html#updating-the-solr-schema
              
        Note: Please see https://guides.dataverse.org/en/latest/admin/metadatacustomization.html for advice on
              how to create your own metadata schemas.
        
        WARNING: Do not remove the following include guards if you intend to use the neat helper scripts we provide.
    -->
    <!-- SCHEMA-COPY-FIELDS::BEGIN -->
    <copyField source="accessToSources" dest="_text_" maxChars="3000"/>
    <copyField source="actionsToMinimizeLoss" dest="_text_" maxChars="3000"/>
    <copyField source="alternativeTitle" dest="_text_" maxChars="3000"/>
    <copyField source="alternativeURL" dest="_text_" maxChars="3000"/>
    <copyField source="astroFacility" dest="_text_" maxChars="3000"/>
    <copyField source="astroInstrument" dest="_text_" maxChars="3000"/>
    <copyField source="astroObject" dest="_text_" maxChars="3000"/>
    <copyField source="astroType" dest="_text_" maxChars="3000"/>
    <copyField source="author" dest="_text_" maxChars="3000"/>
    <copyField source="authorAffiliation" dest="_text_" maxChars="3000"/>
    <copyField source="authorIdentifier" dest="_text_" maxChars="3000"/>
    <copyField source="authorIdentifierScheme" dest="_text_" maxChars="3000"/>
    <copyField source="authorName" dest="_text_" maxChars="3000"/>
    <copyField source="characteristicOfSources" dest="_text_" maxChars="3000"/>
    <copyField source="city" dest="_text_" maxChars="3000"/>
    <copyField source="cleaningOperations" dest="_text_" maxChars="3000"/>
    <copyField source="collectionMode" dest="_text_" maxChars="3000"/>
    <copyField source="collectorTraining" dest="_text_" maxChars="3000"/>
    <copyField source="contributor" dest="_text_" maxChars="3000"/>
    <copyField source="contributorName" dest="_text_" maxChars="3000"/>
    <copyField source="contributorType" dest="_text_" maxChars="3000"/>
    <copyField source="controlOperations" dest="_text_" maxChars="3000"/>
    <copyField source="country" dest="_text_" maxChars="3000"/>
    <copyField source="coverage.Depth" dest="_text_" maxChars="3000"/>
    <copyField source="coverage.ObjectCount" dest="_text_" maxChars="3000"/>
    <copyField source="coverage.ObjectDensity" dest="_text_" maxChars="3000"/>
    <copyField source="coverage.Polarization" dest="_text_" maxChars="3000"/>
    <copyField source="coverage.Redshift.MaximumValue" dest="_text_" maxChars="3000"/>
    <copyField source="coverage.Redshift.MinimumValue" dest="_text_" maxChars="3000"/>
    <copyField source="coverage.RedshiftValue" dest="_text_" maxChars="3000"/>
    <copyField source="coverage.SkyFraction" dest="_text_" maxChars="3000"/>
    <copyField source="coverage.Spatial" dest="_text_" maxChars="3000"/>
    <copyField source="coverage.Spectral.Bandpass" dest="_text_" maxChars="3000"/>
    <copyField source="coverage.Spectral.CentralWavelength" dest="_text_" maxChars="3000"/>
    <copyField source="coverage.Spectral.MaximumWavelength" dest="_text_" maxChars="3000"/>
    <copyField source="coverage.Spectral.MinimumWavelength" dest="_text_" maxChars="3000"/>
    <copyField source="coverage.Spectral.Wavelength" dest="_text_" maxChars="3000"/>
    <copyField source="coverage.Temporal" dest="_text_" maxChars="3000"/>
    <copyField source="coverage.Temporal.StartTime" dest="_text_" maxChars="3000"/>
    <copyField source="coverage.Temporal.StopTime" dest="_text_" maxChars="3000"/>
    <copyField source="dataCollectionSituation" dest="_text_" maxChars="3000"/>
    <copyField source="dataCollector" dest="_text_" maxChars="3000"/>
    <copyField source="dataSources" dest="_text_" maxChars="3000"/>
    <copyField source="datasetContact" dest="_text_" maxChars="3000"/>
    <copyField source="datasetContactAffiliation" dest="_text_" maxChars="3000"/>
    <copyField source="datasetContactEmail" dest="_text_" maxChars="3000"/>
    <copyField source="datasetContactName" dest="_text_" maxChars="3000"/>
    <copyField source="datasetLevelErrorNotes" dest="_text_" maxChars="3000"/>
    <copyField source="dateOfCollection" dest="_text_" maxChars="3000"/>
    <copyField source="dateOfCollectionEnd" dest="_text_" maxChars="3000"/>
    <copyField source="dateOfCollectionStart" dest="_text_" maxChars="3000"/>
    <copyField source="dateOfDeposit" dest="_text_" maxChars="3000"/>
    <copyField source="depositor" dest="_text_" maxChars="3000"/>
    <copyField source="deviationsFromSampleDesign" dest="_text_" maxChars="3000"/>
    <copyField source="distributionDate" dest="_text_" maxChars="3000"/>
    <copyField source="distributor" dest="_text_" maxChars="3000"/>
    <copyField source="distributorAbbreviation" dest="_text_" maxChars="3000"/>
    <copyField source="distributorAffiliation" dest="_text_" maxChars="3000"/>
    <copyField source="distributorLogoURL" dest="_text_" maxChars="3000"/>
    <copyField source="distributorName" dest="_text_" maxChars="3000"/>
    <copyField source="distributorURL" dest="_text_" maxChars="3000"/>
    <copyField source="dsDescription" dest="_text_" maxChars="3000"/>
    <copyField source="dsDescriptionDate" dest="_text_" maxChars="3000"/>
    <copyField source="dsDescriptionValue" dest="_text_" maxChars="3000"/>
    <copyField source="eastLongitude" dest="_text_" maxChars="3000"/>
    <copyField source="frequencyOfDataCollection" dest="_text_" maxChars="3000"/>
    <copyField source="geographicBoundingBox" dest="_text_" maxChars="3000"/>
    <copyField source="geographicCoverage" dest="_text_" maxChars="3000"/>
    <copyField source="geographicUnit" dest="_text_" maxChars="3000"/>
    <copyField source="grantNumber" dest="_text_" maxChars="3000"/>
    <copyField source="grantNumberAgency" dest="_text_" maxChars="3000"/>
    <copyField source="grantNumberValue" dest="_text_" maxChars="3000"/>
    <copyField source="journalArticleType" dest="_text_" maxChars="3000"/>
    <copyField source="journalIssue" dest="_text_" maxChars="3000"/>
    <copyField source="journalPubDate" dest="_text_" maxChars="3000"/>
    <copyField source="journalVolume" dest="_text_" maxChars="3000"/>
    <copyField source="journalVolumeIssue" dest="_text_" maxChars="3000"/>
    <copyField source="keyword" dest="_text_" maxChars="3000"/>
    <copyField source="keywordValue" dest="_text_" maxChars="3000"/>
    <copyField source="keywordVocabulary" dest="_text_" maxChars="3000"/>
    <copyField source="keywordVocabularyURI" dest="_text_" maxChars="3000"/>
    <copyField source="kindOfData" dest="_text_" maxChars="3000"/>
    <copyField source="language" dest="_text_" maxChars="3000"/>
    <copyField source="northLongitude" dest="_text_" maxChars="3000"/>
    <copyField source="notesText" dest="_text_" maxChars="3000"/>
    <copyField source="originOfSources" dest="_text_" maxChars="3000"/>
    <copyField source="otherDataAppraisal" dest="_text_" maxChars="3000"/>
    <copyField source="otherGeographicCoverage" dest="_text_" maxChars="3000"/>
    <copyField source="otherId" dest="_text_" maxChars="3000"/>
    <copyField source="otherIdAgency" dest="_text_" maxChars="3000"/>
    <copyField source="otherIdValue" dest="_text_" maxChars="3000"/>
    <copyField source="otherReferences" dest="_text_" maxChars="3000"/>
    <copyField source="producer" dest="_text_" maxChars="3000"/>
    <copyField source="producerAbbreviation" dest="_text_" maxChars="3000"/>
    <copyField source="producerAffiliation" dest="_text_" maxChars="3000"/>
    <copyField source="producerLogoURL" dest="_text_" maxChars="3000"/>
    <copyField source="producerName" dest="_text_" maxChars="3000"/>
    <copyField source="producerURL" dest="_text_" maxChars="3000"/>
    <copyField source="productionDate" dest="_text_" maxChars="3000"/>
    <copyField source="productionPlace" dest="_text_" maxChars="3000"/>
    <copyField source="publication" dest="_text_" maxChars="3000"/>
    <copyField source="publicationCitation" dest="_text_" maxChars="3000"/>
    <copyField source="publicationIDNumber" dest="_text_" maxChars="3000"/>
    <copyField source="publicationIDType" dest="_text_" maxChars="3000"/>
    <copyField source="publicationURL" dest="_text_" maxChars="3000"/>
    <copyField source="redshiftType" dest="_text_" maxChars="3000"/>
    <copyField source="relatedDatasets" dest="_text_" maxChars="3000"/>
    <copyField source="relatedMaterial" dest="_text_" maxChars="3000"/>
    <copyField source="researchInstrument" dest="_text_" maxChars="3000"/>
    <copyField source="resolution.Redshift" dest="_text_" maxChars="3000"/>
    <copyField source="resolution.Spatial" dest="_text_" maxChars="3000"/>
    <copyField source="resolution.Spectral" dest="_text_" maxChars="3000"/>
    <copyField source="resolution.Temporal" dest="_text_" maxChars="3000"/>
    <copyField source="responseRate" dest="_text_" maxChars="3000"/>
    <copyField source="samplingErrorEstimates" dest="_text_" maxChars="3000"/>
    <copyField source="samplingProcedure" dest="_text_" maxChars="3000"/>
    <copyField source="series" dest="_text_" maxChars="3000"/>
    <copyField source="seriesInformation" dest="_text_" maxChars="3000"/>
    <copyField source="seriesName" dest="_text_" maxChars="3000"/>
    <copyField source="socialScienceNotes" dest="_text_" maxChars="3000"/>
    <copyField source="socialScienceNotesSubject" dest="_text_" maxChars="3000"/>
    <copyField source="socialScienceNotesText" dest="_text_" maxChars="3000"/>
    <copyField source="socialScienceNotesType" dest="_text_" maxChars="3000"/>
    <copyField source="software" dest="_text_" maxChars="3000"/>
    <copyField source="softwareName" dest="_text_" maxChars="3000"/>
    <copyField source="softwareVersion" dest="_text_" maxChars="3000"/>
    <copyField source="southLongitude" dest="_text_" maxChars="3000"/>
    <copyField source="state" dest="_text_" maxChars="3000"/>
    <copyField source="studyAssayCellType" dest="_text_" maxChars="3000"/>
    <copyField source="studyAssayMeasurementType" dest="_text_" maxChars="3000"/>
    <copyField source="studyAssayOrganism" dest="_text_" maxChars="3000"/>
    <copyField source="studyAssayOtherMeasurmentType" dest="_text_" maxChars="3000"/>
    <copyField source="studyAssayOtherOrganism" dest="_text_" maxChars="3000"/>
    <copyField source="studyAssayOtherPlatform" dest="_text_" maxChars="3000"/>
    <copyField source="studyAssayOtherTechnologyType" dest="_text_" maxChars="3000"/>
    <copyField source="studyAssayPlatform" dest="_text_" maxChars="3000"/>
    <copyField source="studyAssayTechnologyType" dest="_text_" maxChars="3000"/>
    <copyField source="studyDesignType" dest="_text_" maxChars="3000"/>
    <copyField source="studyFactorType" dest="_text_" maxChars="3000"/>
    <copyField source="studyOtherDesignType" dest="_text_" maxChars="3000"/>
    <copyField source="studyOtherFactorType" dest="_text_" maxChars="3000"/>
    <copyField source="subject" dest="_text_" maxChars="3000"/>
    <copyField source="subtitle" dest="_text_" maxChars="3000"/>
    <copyField source="targetSampleActualSize" dest="_text_" maxChars="3000"/>
    <copyField source="targetSampleSize" dest="_text_" maxChars="3000"/>
    <copyField source="targetSampleSizeFormula" dest="_text_" maxChars="3000"/>
    <copyField source="timeMethod" dest="_text_" maxChars="3000"/>
    <copyField source="timePeriodCovered" dest="_text_" maxChars="3000"/>
    <copyField source="timePeriodCoveredEnd" dest="_text_" maxChars="3000"/>
    <copyField source="timePeriodCoveredStart" dest="_text_" maxChars="3000"/>
    <copyField source="title" dest="_text_" maxChars="3000"/>
    <copyField source="topicClassValue" dest="_text_" maxChars="3000"/>
    <copyField source="topicClassVocab" dest="_text_" maxChars="3000"/>
    <copyField source="topicClassVocabURI" dest="_text_" maxChars="3000"/>
    <copyField source="topicClassification" dest="_text_" maxChars="3000"/>
    <copyField source="unitOfAnalysis" dest="_text_" maxChars="3000"/>
    <copyField source="universe" dest="_text_" maxChars="3000"/>
    <copyField source="weighting" dest="_text_" maxChars="3000"/>
    <copyField source="westLongitude" dest="_text_" maxChars="3000"/>
    <!-- SCHEMA-COPY-FIELDS::END -->
    
    <!-- This can be enabled, in case the client does not know what fields may be searched. It isn't enabled by default
         because it's very expensive to index everything twice. -->
    <!--<copyField source="*" dest="_text_"/>-->

    <!-- Dynamic field definitions allow using convention over configuration
       for fields via the specification of patterns to match field names.
       EXAMPLE:  name="*_i" will match any field ending in _i (like myid_i, z_i)
       RESTRICTION: the glob-like pattern in the name attribute must have a "*" only at the start or the end.  -->
   
    <dynamicField name="*_i"  type="pint"    indexed="true"  stored="true"/>
    <dynamicField name="*_is" type="pints"    indexed="true"  stored="true"/>
    <dynamicField name="*_s"  type="string"  indexed="true"  stored="true" />
    <dynamicField name="*_ss" type="strings"  indexed="true"  stored="true"/>
    <dynamicField name="*_l"  type="plong"   indexed="true"  stored="true"/>
    <dynamicField name="*_ls" type="plongs"   indexed="true"  stored="true"/>
    <dynamicField name="*_txt" type="text_general" indexed="true" stored="true"/>
    <dynamicField name="*_b"  type="boolean" indexed="true" stored="true"/>
    <dynamicField name="*_bs" type="booleans" indexed="true" stored="true"/>
    <dynamicField name="*_f"  type="pfloat"  indexed="true"  stored="true"/>
    <dynamicField name="*_fs" type="pfloats"  indexed="true"  stored="true"/>
    <dynamicField name="*_d"  type="pdouble" indexed="true"  stored="true"/>
    <dynamicField name="*_ds" type="pdoubles" indexed="true"  stored="true"/>

    <!-- Type used for data-driven schema, to add a string copy for each text field -->
    <dynamicField name="*_str" type="strings" stored="false" docValues="true" indexed="false" />

    <dynamicField name="*_dt"  type="pdate"    indexed="true"  stored="true"/>
    <dynamicField name="*_dts" type="pdate"    indexed="true"  stored="true" multiValued="true"/>
    <dynamicField name="*_p"  type="location" indexed="true" stored="true"/>
    <dynamicField name="*_srpt"  type="location_rpt" indexed="true" stored="true"/>
    
    <!-- payloaded dynamic fields -->
    <dynamicField name="*_dpf" type="delimited_payloads_float" indexed="true"  stored="true"/>
    <dynamicField name="*_dpi" type="delimited_payloads_int" indexed="true"  stored="true"/>
    <dynamicField name="*_dps" type="delimited_payloads_string" indexed="true"  stored="true"/>

    <dynamicField name="attr_*" type="text_general" indexed="true" stored="true" multiValued="true"/>

    <!-- Field to use to determine and enforce document uniqueness.
      Unless this field is marked with required="false", it will be a required field
    -->
    <uniqueKey>id</uniqueKey>

    <!-- copyField commands copy one field to another at the time a document
       is added to the index.  It's used either to index the same field differently,
       or to add multiple fields to the same field for easier/faster searching.

    <copyField source="sourceFieldName" dest="destinationFieldName"/>
    -->

    <!-- field type definitions. The "name" attribute is
       just a label to be used by field definitions.  The "class"
       attribute and any other attributes determine the real
       behavior of the fieldType.
         Class names starting with "solr" refer to java classes in a
       standard package such as org.apache.solr.analysis
    -->

    <!-- sortMissingLast and sortMissingFirst attributes are optional attributes are
         currently supported on types that are sorted internally as strings
         and on numeric types.
       This includes "string", "boolean", "pint", "pfloat", "plong", "pdate", "pdouble".
       - If sortMissingLast="true", then a sort on this field will cause documents
         without the field to come after documents with the field,
         regardless of the requested sort order (asc or desc).
       - If sortMissingFirst="true", then a sort on this field will cause documents
         without the field to come before documents with the field,
         regardless of the requested sort order.
       - If sortMissingLast="false" and sortMissingFirst="false" (the default),
         then default lucene sorting will be used which places docs without the
         field first in an ascending sort and last in a descending sort.
    -->

<fieldType name="int" class="solr.TrieIntField" precisionStep="0" positionIncrementGap="0"/>
<fieldType name="float" class="solr.TrieFloatField" precisionStep="0" positionIncrementGap="0"/>
<fieldType name="long" class="solr.TrieLongField" precisionStep="0" positionIncrementGap="0"/>
<fieldType name="double" class="solr.TrieDoubleField" precisionStep="0" positionIncrementGap="0"/>

<fieldType name="tint" class="solr.TrieIntField" precisionStep="8" positionIncrementGap="0"/>
<fieldType name="tfloat" class="solr.TrieFloatField" precisionStep="8" positionIncrementGap="0"/>
<fieldType name="tlong" class="solr.TrieLongField" precisionStep="8" positionIncrementGap="0"/>
<fieldType name="tdouble" class="solr.TrieDoubleField" precisionStep="8" positionIncrementGap="0"/>

<!-- The format for this date field is of the form 1995-12-31T23:59:59Z, and
        is a more restricted form of the canonical representation of dateTime
        http://www.w3.org/TR/xmlschema-2/#dateTime    
        The trailing "Z" designates UTC time and is mandatory.
        Optional fractional seconds are allowed: 1995-12-31T23:59:59.999Z
        All other components are mandatory.

        Expressions can also be used to denote calculations that should be
        performed relative to "NOW" to determine the value, ie...

            NOW/HOUR
                ... Round to the start of the current hour
            NOW-1DAY
                ... Exactly 1 day prior to now
            NOW/DAY+6MONTHS+3DAYS
                ... 6 months and 3 days in the future from the start of
                    the current day
                    
        Consult the DateField javadocs for more information.

        Note: For faster range queries, consider the tdate type
    -->
    <fieldType name="date" class="solr.TrieDateField" precisionStep="0" positionIncrementGap="0"/>

    <!-- A Trie based date field for faster date range queries and date faceting. -->
    <fieldType name="tdate" class="solr.TrieDateField" precisionStep="6" positionIncrementGap="0"/>

    <!-- This is an example of using the KeywordTokenizer along
        With various TokenFilterFactories to produce a sortable field
        that does not include some properties of the source text
    -->
    <fieldType name="alphaOnlySort" class="solr.TextField" sortMissingLast="true" omitNorms="true">
        <analyzer>
        <!-- KeywordTokenizer does no actual tokenizing, so the entire
                input string is preserved as a single token
            -->
        <tokenizer class="solr.KeywordTokenizerFactory"/>
        <!-- The LowerCase TokenFilter does what you expect, which can be
                when you want your sorting to be case insensitive
            -->
        <filter class="solr.LowerCaseFilterFactory" />
        <!-- The TrimFilter removes any leading or trailing whitespace -->
        <filter class="solr.TrimFilterFactory" />
        <!-- The PatternReplaceFilter gives you the flexibility to use
                Java Regular expression to replace any sequence of characters
                matching a pattern with an arbitrary replacement string, 
                which may include back references to portions of the original
                string matched by the pattern.

                See the Java Regular Expression documentation for more
                information on pattern and replacement string syntax.

                http://java.sun.com/j2se/1.6.0/docs/api/java/util/regex/package-summary.html
            -->
        <!-- commented out for Dataverse 4.0 alpha 1 because Kangaroos was being sorted before 2Legit2Quit -->
        <!-- https://redmine.hmdc.harvard.edu/issues/3482#note-11 -->
        <!-- <filter class="solr.PatternReplaceFilterFactory" pattern="([^a-z])" replacement="" replace="all" /> -->
        </analyzer>
    </fieldType>   
    
    <!-- The StrField type is not analyzed, but indexed/stored verbatim. -->
    <fieldType name="string" class="solr.StrField" sortMissingLast="true" docValues="true" />
    <fieldType name="strings" class="solr.StrField" sortMissingLast="true" multiValued="true" docValues="true" />

    <!-- boolean type: "true" or "false" -->
    <fieldType name="boolean" class="solr.BoolField" sortMissingLast="true"/>
    <fieldType name="booleans" class="solr.BoolField" sortMissingLast="true" multiValued="true"/>

    <!--
      Numeric field types that index values using KD-trees.
      Point fields don't support FieldCache, so they must have docValues="true" if needed for sorting, faceting, functions, etc.
    -->
    <fieldType name="pint" class="solr.IntPointField" docValues="true"/>
    <fieldType name="pfloat" class="solr.FloatPointField" docValues="true"/>
    <fieldType name="plong" class="solr.LongPointField" docValues="true"/>
    <fieldType name="pdouble" class="solr.DoublePointField" docValues="true"/>
    
    <fieldType name="pints" class="solr.IntPointField" docValues="true" multiValued="true"/>
    <fieldType name="pfloats" class="solr.FloatPointField" docValues="true" multiValued="true"/>
    <fieldType name="plongs" class="solr.LongPointField" docValues="true" multiValued="true"/>
    <fieldType name="pdoubles" class="solr.DoublePointField" docValues="true" multiValued="true"/>

    <!-- The format for this date field is of the form 1995-12-31T23:59:59Z, and
         is a more restricted form of the canonical representation of dateTime
         http://www.w3.org/TR/xmlschema-2/#dateTime    
         The trailing "Z" designates UTC time and is mandatory.
         Optional fractional seconds are allowed: 1995-12-31T23:59:59.999Z
         All other components are mandatory.

         Expressions can also be used to denote calculations that should be
         performed relative to "NOW" to determine the value, ie...

               NOW/HOUR
                  ... Round to the start of the current hour
               NOW-1DAY
                  ... Exactly 1 day prior to now
               NOW/DAY+6MONTHS+3DAYS
                  ... 6 months and 3 days in the future from the start of
                      the current day
                      
      -->
    <!-- KD-tree versions of date fields -->
    <fieldType name="pdate" class="solr.DatePointField" docValues="true"/>
    <fieldType name="pdates" class="solr.DatePointField" docValues="true" multiValued="true"/>
    
    <!--Binary data type. The data should be sent/retrieved in as Base64 encoded Strings -->
    <fieldType name="binary" class="solr.BinaryField"/>

    <!-- solr.TextField allows the specification of custom text analyzers
         specified as a tokenizer and a list of token filters. Different
         analyzers may be specified for indexing and querying.

         The optional positionIncrementGap puts space between multiple fields of
         this type on the same document, with the purpose of preventing false phrase
         matching across fields.

         For more info on customizing your analyzer chain, please see
         http://lucene.apache.org/solr/guide/understanding-analyzers-tokenizers-and-filters.html#understanding-analyzers-tokenizers-and-filters
     -->

    <!-- One can also specify an existing Analyzer class that has a
         default constructor via the class attribute on the analyzer element.
         Example:
    <fieldType name="text_greek" class="solr.TextField">
      <analyzer class="org.apache.lucene.analysis.el.GreekAnalyzer"/>
    </fieldType>
    -->

    <!-- A text field that only splits on whitespace for exact matching of words -->
    <dynamicField name="*_ws" type="text_ws"  indexed="true"  stored="true"/>
    <fieldType name="text_ws" class="solr.TextField" positionIncrementGap="100">
      <analyzer>
        <tokenizer class="solr.WhitespaceTokenizerFactory"/>
      </analyzer>
    </fieldType>

    <!-- A general text field that has reasonable, generic
         cross-language defaults: it tokenizes with StandardTokenizer,
	       removes stop words from case-insensitive "stopwords.txt"
	       (empty by default), and down cases.  At query time only, it
	       also applies synonyms.
	  -->
    <fieldType name="text_general" class="solr.TextField" positionIncrementGap="100" multiValued="true">
      <analyzer type="index">
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="stopwords.txt" />
        <!-- in this example, we will only use synonyms at query time
        <filter class="solr.SynonymGraphFilterFactory" synonyms="index_synonyms.txt" ignoreCase="true" expand="false"/>
        <filter class="solr.FlattenGraphFilterFactory"/>
        -->
        <filter class="solr.LowerCaseFilterFactory"/>
      </analyzer>
      <analyzer type="query">
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="stopwords.txt" />
        <filter class="solr.SynonymGraphFilterFactory" synonyms="synonyms.txt" ignoreCase="true" expand="true"/>
        <filter class="solr.LowerCaseFilterFactory"/>
      </analyzer>
    </fieldType>

    <!-- A text field with defaults appropriate for English: it tokenizes with StandardTokenizer,
         removes English stop words (lang/stopwords_en.txt), down cases, protects words from protwords.txt, and
         finally applies Porter's stemming.  The query time analyzer also applies synonyms from synonyms.txt. -->
    <dynamicField name="*_txt_en" type="text_en"  indexed="true"  stored="true"/>
    <fieldType name="text_en" class="solr.TextField" positionIncrementGap="100">
        <analyzer type="index">
            <tokenizer class="solr.StandardTokenizerFactory"/>
                        <!-- in this example, we will only use synonyms at query time
                        <filter class="solr.SynonymGraphFilterFactory" synonyms="index_synonyms.txt" ignoreCase="true" expand="false"/>
                        <filter class="solr.FlattenGraphFilterFactory"/>
                        -->
                        <!-- Case insensitive stop word removal.
                        -->
            <filter class="solr.StopFilterFactory"
                    ignoreCase="true"
                    words="lang/stopwords_en.txt"
                />
            
            <filter class="solr.LowerCaseFilterFactory"/>
            <filter class="solr.EnglishPossessiveFilterFactory"/>
            <filter class="solr.KeywordMarkerFilterFactory" protected="protwords.txt"/>
            
            <!-- Solved highlighting breaking after upgrade #4836. Applied to query analyzer below too: 
                https://stackoverflow.com/questions/26287321/solr-stemming-breaks-highlighting 
                Solution was to ensure original word is kept by stemmer -MAD 4.9.2 -->
            <filter class="solr.KeywordRepeatFilterFactory" />
            <filter class="solr.PorterStemFilterFactory"/>
            <filter class="solr.RemoveDuplicatesTokenFilterFactory"/>
            <filter class="solr.ASCIIFoldingFilterFactory" preserveOriginal="true" />
        </analyzer>
        <analyzer type="query">
            <tokenizer class="solr.StandardTokenizerFactory"/>
            
            <!-- MAD 4.9.2: Solr recommends doing synonym expansion at index not query, why do we do it here tho? 
                    https://stackoverflow.com/questions/10185079/ 
                    To me it looks like we we copied something that works-->
            <filter class="solr.SynonymGraphFilterFactory" synonyms="synonyms.txt" ignoreCase="true" expand="true"/>
            <filter class="solr.StopFilterFactory"
                    ignoreCase="true"
                    words="lang/stopwords_en.txt"
                />
            
            <filter class="solr.LowerCaseFilterFactory"/>
            <filter class="solr.EnglishPossessiveFilterFactory"/>
            <filter class="solr.KeywordMarkerFilterFactory" protected="protwords.txt"/>

            <filter class="solr.KeywordRepeatFilterFactory" />
            <filter class="solr.PorterStemFilterFactory"/>
            <filter class="solr.RemoveDuplicatesTokenFilterFactory"/>
        </analyzer>
    </fieldType>

    <!-- A text field with defaults appropriate for English, plus
         aggressive word-splitting and autophrase features enabled.
         This field is just like text_en, except it adds
         WordDelimiterGraphFilter to enable splitting and matching of
         words on case-change, alpha numeric boundaries, and
         non-alphanumeric chars.  This means certain compound word
         cases will work, for example query "wi fi" will match
         document "WiFi" or "wi-fi".
    -->
    <dynamicField name="*_txt_en_split" type="text_en_splitting"  indexed="true"  stored="true"/>
    <fieldType name="text_en_splitting" class="solr.TextField" positionIncrementGap="100" autoGeneratePhraseQueries="true">
      <analyzer type="index">
        <tokenizer class="solr.WhitespaceTokenizerFactory"/>
        <!-- in this example, we will only use synonyms at query time
        <filter class="solr.SynonymGraphFilterFactory" synonyms="index_synonyms.txt" ignoreCase="true" expand="false"/>
        -->
        <!-- Case insensitive stop word removal.
        -->
        <filter class="solr.StopFilterFactory"
                ignoreCase="true"
                words="lang/stopwords_en.txt"
        />
        <filter class="solr.WordDelimiterGraphFilterFactory" generateWordParts="1" generateNumberParts="1" catenateWords="1" catenateNumbers="1" catenateAll="0" splitOnCaseChange="1"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.KeywordMarkerFilterFactory" protected="protwords.txt"/>
        <filter class="solr.PorterStemFilterFactory"/>
        <filter class="solr.FlattenGraphFilterFactory" />
        <filter class="solr.ASCIIFoldingFilterFactory" preserveOriginal="true" />
      </analyzer>
      <analyzer type="query">
        <tokenizer class="solr.WhitespaceTokenizerFactory"/>
        <filter class="solr.SynonymGraphFilterFactory" synonyms="synonyms.txt" ignoreCase="true" expand="true"/>
        <filter class="solr.StopFilterFactory"
                ignoreCase="true"
                words="lang/stopwords_en.txt"
        />
        <filter class="solr.WordDelimiterGraphFilterFactory" generateWordParts="1" generateNumberParts="1" catenateWords="0" catenateNumbers="0" catenateAll="0" splitOnCaseChange="1"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.KeywordMarkerFilterFactory" protected="protwords.txt"/>
        <filter class="solr.PorterStemFilterFactory"/>
      </analyzer>
    </fieldType>

    <!-- Less flexible matching, but less false matches.  Probably not ideal for product names,
         but may be good for SKUs.  Can insert dashes in the wrong place and still match. -->
    <dynamicField name="*_txt_en_split_tight" type="text_en_splitting_tight"  indexed="true"  stored="true"/>
    <fieldType name="text_en_splitting_tight" class="solr.TextField" positionIncrementGap="100" autoGeneratePhraseQueries="true">
      <analyzer type="index">
        <tokenizer class="solr.WhitespaceTokenizerFactory"/>
        <filter class="solr.SynonymGraphFilterFactory" synonyms="synonyms.txt" ignoreCase="true" expand="false"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_en.txt"/>
        <filter class="solr.WordDelimiterGraphFilterFactory" generateWordParts="0" generateNumberParts="0" catenateWords="1" catenateNumbers="1" catenateAll="0"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.KeywordMarkerFilterFactory" protected="protwords.txt"/>
        <filter class="solr.EnglishMinimalStemFilterFactory"/>
        <!-- this filter can remove any duplicate tokens that appear at the same position - sometimes
             possible with WordDelimiterGraphFilter in conjuncton with stemming. -->
        <filter class="solr.RemoveDuplicatesTokenFilterFactory"/>
        <filter class="solr.FlattenGraphFilterFactory" />
      </analyzer>
      <analyzer type="query">
        <tokenizer class="solr.WhitespaceTokenizerFactory"/>
        <filter class="solr.SynonymGraphFilterFactory" synonyms="synonyms.txt" ignoreCase="true" expand="false"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_en.txt"/>
        <filter class="solr.WordDelimiterGraphFilterFactory" generateWordParts="0" generateNumberParts="0" catenateWords="1" catenateNumbers="1" catenateAll="0"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.KeywordMarkerFilterFactory" protected="protwords.txt"/>
        <filter class="solr.EnglishMinimalStemFilterFactory"/>
        <!-- this filter can remove any duplicate tokens that appear at the same position - sometimes
             possible with WordDelimiterGraphFilter in conjuncton with stemming. -->
        <filter class="solr.RemoveDuplicatesTokenFilterFactory"/>
      </analyzer>
    </fieldType>

    <!-- Just like text_general except it reverses the characters of
	       each token, to enable more efficient leading wildcard queries.
    -->
    <dynamicField name="*_txt_rev" type="text_general_rev"  indexed="true"  stored="true"/>
    <fieldType name="text_general_rev" class="solr.TextField" positionIncrementGap="100">
      <analyzer type="index">
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="stopwords.txt" />
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.ReversedWildcardFilterFactory" withOriginal="true"
                maxPosAsterisk="3" maxPosQuestion="2" maxFractionAsterisk="0.33"/>
      </analyzer>
      <analyzer type="query">
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.SynonymGraphFilterFactory" synonyms="synonyms.txt" ignoreCase="true" expand="true"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="stopwords.txt" />
        <filter class="solr.LowerCaseFilterFactory"/>
      </analyzer>
    </fieldType>

    <dynamicField name="*_phon_en" type="phonetic_en"  indexed="true"  stored="true"/>
    <fieldType name="phonetic_en" stored="false" indexed="true" class="solr.TextField" >
      <analyzer>
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.DoubleMetaphoneFilterFactory" inject="false"/>
      </analyzer>
    </fieldType>

    <!-- lowercases the entire field value, keeping it as a single token.  -->
    <dynamicField name="*_s_lower" type="lowercase"  indexed="true"  stored="true"/>
    <fieldType name="lowercase" class="solr.TextField" positionIncrementGap="100">
      <analyzer>
        <tokenizer class="solr.KeywordTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory" />
      </analyzer>
    </fieldType>

    <!-- 
      Example of using PathHierarchyTokenizerFactory at index time, so
      queries for paths match documents at that path, or in descendent paths
    -->
    <dynamicField name="*_descendent_path" type="descendent_path"  indexed="true"  stored="true"/>
    <fieldType name="descendent_path" class="solr.TextField">
      <analyzer type="index">
        <tokenizer class="solr.PathHierarchyTokenizerFactory" delimiter="/" />
      </analyzer>
      <analyzer type="query">
        <tokenizer class="solr.KeywordTokenizerFactory" />
      </analyzer>
    </fieldType>

    <!--
      Example of using PathHierarchyTokenizerFactory at query time, so
      queries for paths match documents at that path, or in ancestor paths
    -->
    <dynamicField name="*_ancestor_path" type="ancestor_path"  indexed="true"  stored="true"/>
    <fieldType name="ancestor_path" class="solr.TextField">
      <analyzer type="index">
        <tokenizer class="solr.KeywordTokenizerFactory" />
      </analyzer>
      <analyzer type="query">
        <tokenizer class="solr.PathHierarchyTokenizerFactory" delimiter="/" />
      </analyzer>
    </fieldType>

    <!-- This point type indexes the coordinates as separate fields (subFields)
      If subFieldType is defined, it references a type, and a dynamic field
      definition is created matching *___<typename>.  Alternately, if 
      subFieldSuffix is defined, that is used to create the subFields.
      Example: if subFieldType="double", then the coordinates would be
        indexed in fields myloc_0___double,myloc_1___double.
      Example: if subFieldSuffix="_d" then the coordinates would be indexed
        in fields myloc_0_d,myloc_1_d
      The subFields are an implementation detail of the fieldType, and end
      users normally should not need to know about them.
     -->
    <dynamicField name="*_point" type="point"  indexed="true"  stored="true"/>
    <fieldType name="point" class="solr.PointType" dimension="2" subFieldSuffix="_d"/>

    <!-- A specialized field for geospatial search filters and distance sorting. -->
    <fieldType name="location" class="solr.LatLonPointSpatialField" docValues="true"/>

    <!-- A geospatial field type that supports multiValued and polygon shapes.
      For more information about this and other spatial fields see:
      http://lucene.apache.org/solr/guide/spatial-search.html
    -->
    <fieldType name="location_rpt" class="solr.SpatialRecursivePrefixTreeFieldType"
               geo="true" distErrPct="0.025" maxDistErr="0.001" distanceUnits="kilometers" />

    <!-- Payloaded field types -->
    <fieldType name="delimited_payloads_float" stored="false" indexed="true" class="solr.TextField">
      <analyzer>
        <tokenizer class="solr.WhitespaceTokenizerFactory"/>
        <filter class="solr.DelimitedPayloadTokenFilterFactory" encoder="float"/>
      </analyzer>
    </fieldType>
    <fieldType name="delimited_payloads_int" stored="false" indexed="true" class="solr.TextField">
      <analyzer>
        <tokenizer class="solr.WhitespaceTokenizerFactory"/>
        <filter class="solr.DelimitedPayloadTokenFilterFactory" encoder="integer"/>
      </analyzer>
    </fieldType>
    <fieldType name="delimited_payloads_string" stored="false" indexed="true" class="solr.TextField">
      <analyzer>
        <tokenizer class="solr.WhitespaceTokenizerFactory"/>
        <filter class="solr.DelimitedPayloadTokenFilterFactory" encoder="identity"/>
      </analyzer>
    </fieldType>

    <!-- some examples for different languages (generally ordered by ISO code) -->

    <!-- Arabic -->
    <dynamicField name="*_txt_ar" type="text_ar"  indexed="true"  stored="true"/>
    <fieldType name="text_ar" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <!-- for any non-arabic -->
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_ar.txt" />
        <!-- normalizes ﻯ to ﻱ, etc -->
        <filter class="solr.ArabicNormalizationFilterFactory"/>
        <filter class="solr.ArabicStemFilterFactory"/>
      </analyzer>
    </fieldType>

    <!-- Bulgarian -->
    <dynamicField name="*_txt_bg" type="text_bg"  indexed="true"  stored="true"/>
    <fieldType name="text_bg" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/> 
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_bg.txt" /> 
        <filter class="solr.BulgarianStemFilterFactory"/>       
      </analyzer>
    </fieldType>
    
    <!-- Catalan -->
    <dynamicField name="*_txt_ca" type="text_ca"  indexed="true"  stored="true"/>
    <fieldType name="text_ca" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <!-- removes l', etc -->
        <filter class="solr.ElisionFilterFactory" ignoreCase="true" articles="lang/contractions_ca.txt"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_ca.txt" />
        <filter class="solr.SnowballPorterFilterFactory" language="Catalan"/>       
      </analyzer>
    </fieldType>
    
    <!-- CJK bigram (see text_ja for a Japanese configuration using morphological analysis) -->
    <dynamicField name="*_txt_cjk" type="text_cjk"  indexed="true"  stored="true"/>
    <fieldType name="text_cjk" class="solr.TextField" positionIncrementGap="100">
      <analyzer>
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <!-- normalize width before bigram, as e.g. half-width dakuten combine  -->
        <filter class="solr.CJKWidthFilterFactory"/>
        <!-- for any non-CJK -->
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.CJKBigramFilterFactory"/>
      </analyzer>
    </fieldType>

    <!-- Czech -->
    <dynamicField name="*_txt_cz" type="text_cz"  indexed="true"  stored="true"/>
    <fieldType name="text_cz" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_cz.txt" />
        <filter class="solr.CzechStemFilterFactory"/>       
      </analyzer>
    </fieldType>
    
    <!-- Danish -->
    <dynamicField name="*_txt_da" type="text_da"  indexed="true"  stored="true"/>
    <fieldType name="text_da" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_da.txt" format="snowball" />
        <filter class="solr.SnowballPorterFilterFactory" language="Danish"/>       
      </analyzer>
    </fieldType>
    
    <!-- German -->
    <dynamicField name="*_txt_de" type="text_de"  indexed="true"  stored="true"/>
    <fieldType name="text_de" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_de.txt" format="snowball" />
        <filter class="solr.GermanNormalizationFilterFactory"/>
        <filter class="solr.GermanLightStemFilterFactory"/>
        <!-- less aggressive: <filter class="solr.GermanMinimalStemFilterFactory"/> -->
        <!-- more aggressive: <filter class="solr.SnowballPorterFilterFactory" language="German2"/> -->
      </analyzer>
    </fieldType>
    
    <!-- Greek -->
    <dynamicField name="*_txt_el" type="text_el"  indexed="true"  stored="true"/>
    <fieldType name="text_el" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <!-- greek specific lowercase for sigma -->
        <filter class="solr.GreekLowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="false" words="lang/stopwords_el.txt" />
        <filter class="solr.GreekStemFilterFactory"/>
      </analyzer>
    </fieldType>
    
    <!-- Spanish -->
    <dynamicField name="*_txt_es" type="text_es"  indexed="true"  stored="true"/>
    <fieldType name="text_es" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_es.txt" format="snowball" />
        <filter class="solr.SpanishLightStemFilterFactory"/>
        <!-- more aggressive: <filter class="solr.SnowballPorterFilterFactory" language="Spanish"/> -->
      </analyzer>
    </fieldType>
    
    <!-- Basque -->
    <dynamicField name="*_txt_eu" type="text_eu"  indexed="true"  stored="true"/>
    <fieldType name="text_eu" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_eu.txt" />
        <filter class="solr.SnowballPorterFilterFactory" language="Basque"/>
      </analyzer>
    </fieldType>
    
    <!-- Persian -->
    <dynamicField name="*_txt_fa" type="text_fa"  indexed="true"  stored="true"/>
    <fieldType name="text_fa" class="solr.TextField" positionIncrementGap="100">
      <analyzer>
        <!-- for ZWNJ -->
        <charFilter class="solr.PersianCharFilterFactory"/>
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.ArabicNormalizationFilterFactory"/>
        <filter class="solr.PersianNormalizationFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_fa.txt" />
      </analyzer>
    </fieldType>
    
    <!-- Finnish -->
    <dynamicField name="*_txt_fi" type="text_fi"  indexed="true"  stored="true"/>
    <fieldType name="text_fi" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_fi.txt" format="snowball" />
        <filter class="solr.SnowballPorterFilterFactory" language="Finnish"/>
        <!-- less aggressive: <filter class="solr.FinnishLightStemFilterFactory"/> -->
      </analyzer>
    </fieldType>
    
    <!-- French -->
    <dynamicField name="*_txt_fr" type="text_fr"  indexed="true"  stored="true"/>
    <fieldType name="text_fr" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <!-- removes l', etc -->
        <filter class="solr.ElisionFilterFactory" ignoreCase="true" articles="lang/contractions_fr.txt"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_fr.txt" format="snowball" />
        <filter class="solr.FrenchLightStemFilterFactory"/>
        <!-- less aggressive: <filter class="solr.FrenchMinimalStemFilterFactory"/> -->
        <!-- more aggressive: <filter class="solr.SnowballPorterFilterFactory" language="French"/> -->
      </analyzer>
    </fieldType>
    
    <!-- Irish -->
    <dynamicField name="*_txt_ga" type="text_ga"  indexed="true"  stored="true"/>
    <fieldType name="text_ga" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <!-- removes d', etc -->
        <filter class="solr.ElisionFilterFactory" ignoreCase="true" articles="lang/contractions_ga.txt"/>
        <!-- removes n-, etc. position increments is intentionally false! -->
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/hyphenations_ga.txt"/>
        <filter class="solr.IrishLowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_ga.txt"/>
        <filter class="solr.SnowballPorterFilterFactory" language="Irish"/>
      </analyzer>
    </fieldType>
    
    <!-- Galician -->
    <dynamicField name="*_txt_gl" type="text_gl"  indexed="true"  stored="true"/>
    <fieldType name="text_gl" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_gl.txt" />
        <filter class="solr.GalicianStemFilterFactory"/>
        <!-- less aggressive: <filter class="solr.GalicianMinimalStemFilterFactory"/> -->
      </analyzer>
    </fieldType>
    
    <!-- Hindi -->
    <dynamicField name="*_txt_hi" type="text_hi"  indexed="true"  stored="true"/>
    <fieldType name="text_hi" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <!-- normalizes unicode representation -->
        <filter class="solr.IndicNormalizationFilterFactory"/>
        <!-- normalizes variation in spelling -->
        <filter class="solr.HindiNormalizationFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_hi.txt" />
        <filter class="solr.HindiStemFilterFactory"/>
      </analyzer>
    </fieldType>
    
    <!-- Hungarian -->
    <dynamicField name="*_txt_hu" type="text_hu"  indexed="true"  stored="true"/>
    <fieldType name="text_hu" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_hu.txt" format="snowball" />
        <filter class="solr.SnowballPorterFilterFactory" language="Hungarian"/>
        <!-- less aggressive: <filter class="solr.HungarianLightStemFilterFactory"/> -->   
      </analyzer>
    </fieldType>
    
    <!-- Armenian -->
    <dynamicField name="*_txt_hy" type="text_hy"  indexed="true"  stored="true"/>
    <fieldType name="text_hy" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_hy.txt" />
        <filter class="solr.SnowballPorterFilterFactory" language="Armenian"/>
      </analyzer>
    </fieldType>
    
    <!-- Indonesian -->
    <dynamicField name="*_txt_id" type="text_id"  indexed="true"  stored="true"/>
    <fieldType name="text_id" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_id.txt" />
        <!-- for a less aggressive approach (only inflectional suffixes), set stemDerivational to false -->
        <filter class="solr.IndonesianStemFilterFactory" stemDerivational="true"/>
      </analyzer>
    </fieldType>
    
    <!-- Italian -->
  <dynamicField name="*_txt_it" type="text_it"  indexed="true"  stored="true"/>
  <fieldType name="text_it" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <!-- removes l', etc -->
        <filter class="solr.ElisionFilterFactory" ignoreCase="true" articles="lang/contractions_it.txt"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_it.txt" format="snowball" />
        <filter class="solr.ItalianLightStemFilterFactory"/>
        <!-- more aggressive: <filter class="solr.SnowballPorterFilterFactory" language="Italian"/> -->
      </analyzer>
    </fieldType>
    
    <!-- Japanese using morphological analysis (see text_cjk for a configuration using bigramming)

         NOTE: If you want to optimize search for precision, use default operator AND in your request
         handler config (q.op) Use OR if you would like to optimize for recall (default).
    -->
    <dynamicField name="*_txt_ja" type="text_ja"  indexed="true"  stored="true"/>
    <fieldType name="text_ja" class="solr.TextField" positionIncrementGap="100" autoGeneratePhraseQueries="false">
      <analyzer>
        <!-- Kuromoji Japanese morphological analyzer/tokenizer (JapaneseTokenizer)

           Kuromoji has a search mode (default) that does segmentation useful for search.  A heuristic
           is used to segment compounds into its parts and the compound itself is kept as synonym.

           Valid values for attribute mode are:
              normal: regular segmentation
              search: segmentation useful for search with synonyms compounds (default)
            extended: same as search mode, but unigrams unknown words (experimental)

           For some applications it might be good to use search mode for indexing and normal mode for
           queries to reduce recall and prevent parts of compounds from being matched and highlighted.
           Use <analyzer type="index"> and <analyzer type="query"> for this and mode normal in query.

           Kuromoji also has a convenient user dictionary feature that allows overriding the statistical
           model with your own entries for segmentation, part-of-speech tags and readings without a need
           to specify weights.  Notice that user dictionaries have not been subject to extensive testing.

           User dictionary attributes are:
                     userDictionary: user dictionary filename
             userDictionaryEncoding: user dictionary encoding (default is UTF-8)

           See lang/userdict_ja.txt for a sample user dictionary file.

           Punctuation characters are discarded by default.  Use discardPunctuation="false" to keep them.
        -->
        <tokenizer class="solr.JapaneseTokenizerFactory" mode="search"/>
        <!--<tokenizer class="solr.JapaneseTokenizerFactory" mode="search" userDictionary="lang/userdict_ja.txt"/>-->
        <!-- Reduces inflected verbs and adjectives to their base/dictionary forms (辞書形) -->
        <filter class="solr.JapaneseBaseFormFilterFactory"/>
        <!-- Removes tokens with certain part-of-speech tags -->
        <filter class="solr.JapanesePartOfSpeechStopFilterFactory" tags="lang/stoptags_ja.txt" />
        <!-- Normalizes full-width romaji to half-width and half-width kana to full-width (Unicode NFKC subset) -->
        <filter class="solr.CJKWidthFilterFactory"/>
        <!-- Removes common tokens typically not useful for search, but have a negative effect on ranking -->
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_ja.txt" />
        <!-- Normalizes common katakana spelling variations by removing any last long sound character (U+30FC) -->
        <filter class="solr.JapaneseKatakanaStemFilterFactory" minimumLength="4"/>
        <!-- Lower-cases romaji characters -->
        <filter class="solr.LowerCaseFilterFactory"/>
      </analyzer>
    </fieldType>
    
    <!-- Latvian -->
    <dynamicField name="*_txt_lv" type="text_lv"  indexed="true"  stored="true"/>
    <fieldType name="text_lv" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_lv.txt" />
        <filter class="solr.LatvianStemFilterFactory"/>
      </analyzer>
    </fieldType>
    
    <!-- Dutch -->
    <dynamicField name="*_txt_nl" type="text_nl"  indexed="true"  stored="true"/>
    <fieldType name="text_nl" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_nl.txt" format="snowball" />
        <filter class="solr.StemmerOverrideFilterFactory" dictionary="lang/stemdict_nl.txt" ignoreCase="false"/>
        <filter class="solr.SnowballPorterFilterFactory" language="Dutch"/>
      </analyzer>
    </fieldType>
    
    <!-- Norwegian -->
    <dynamicField name="*_txt_no" type="text_no"  indexed="true"  stored="true"/>
    <fieldType name="text_no" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_no.txt" format="snowball" />
        <filter class="solr.SnowballPorterFilterFactory" language="Norwegian"/>
        <!-- less aggressive: <filter class="solr.NorwegianLightStemFilterFactory"/> -->
        <!-- singular/plural: <filter class="solr.NorwegianMinimalStemFilterFactory"/> -->
      </analyzer>
    </fieldType>
    
    <!-- Portuguese -->
  <dynamicField name="*_txt_pt" type="text_pt"  indexed="true"  stored="true"/>
  <fieldType name="text_pt" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_pt.txt" format="snowball" />
        <filter class="solr.PortugueseLightStemFilterFactory"/>
        <!-- less aggressive: <filter class="solr.PortugueseMinimalStemFilterFactory"/> -->
        <!-- more aggressive: <filter class="solr.SnowballPorterFilterFactory" language="Portuguese"/> -->
        <!-- most aggressive: <filter class="solr.PortugueseStemFilterFactory"/> -->
      </analyzer>
    </fieldType>
    
    <!-- Romanian -->
    <dynamicField name="*_txt_ro" type="text_ro"  indexed="true"  stored="true"/>
    <fieldType name="text_ro" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_ro.txt" />
        <filter class="solr.SnowballPorterFilterFactory" language="Romanian"/>
      </analyzer>
    </fieldType>
    
    <!-- Russian -->
    <dynamicField name="*_txt_ru" type="text_ru"  indexed="true"  stored="true"/>
    <fieldType name="text_ru" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_ru.txt" format="snowball" />
        <filter class="solr.SnowballPorterFilterFactory" language="Russian"/>
        <!-- less aggressive: <filter class="solr.RussianLightStemFilterFactory"/> -->
      </analyzer>
    </fieldType>
    
    <!-- Swedish -->
    <dynamicField name="*_txt_sv" type="text_sv"  indexed="true"  stored="true"/>
    <fieldType name="text_sv" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_sv.txt" format="snowball" />
        <filter class="solr.SnowballPorterFilterFactory" language="Swedish"/>
        <!-- less aggressive: <filter class="solr.SwedishLightStemFilterFactory"/> -->
      </analyzer>
    </fieldType>
    
    <!-- Thai -->
    <dynamicField name="*_txt_th" type="text_th"  indexed="true"  stored="true"/>
    <fieldType name="text_th" class="solr.TextField" positionIncrementGap="100">
      <analyzer>
        <tokenizer class="solr.ThaiTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_th.txt" />
      </analyzer>
    </fieldType>
    
    <!-- Turkish -->
    <dynamicField name="*_txt_tr" type="text_tr"  indexed="true"  stored="true"/>
    <fieldType name="text_tr" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.TurkishLowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="false" words="lang/stopwords_tr.txt" />
        <filter class="solr.SnowballPorterFilterFactory" language="Turkish"/>
      </analyzer>
    </fieldType>

    <!-- Similarity is the scoring routine for each document vs. a query.
       A custom Similarity or SimilarityFactory may be specified here, but 
       the default is fine for most applications.  
       For more info: http://lucene.apache.org/solr/guide/other-schema-elements.html#OtherSchemaElements-Similarity
    -->
    <!--
     <similarity class="com.example.solr.CustomSimilarityFactory">
       <str name="paramkey">param value</str>
     </similarity>
    -->

</schema>
