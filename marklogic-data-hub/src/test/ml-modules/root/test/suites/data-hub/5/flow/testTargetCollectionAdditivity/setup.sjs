declareUpdate();

const hubTest = require("/test/data-hub-test-helper.sjs");
const hubTestX = require("/test/data-hub-test-helper.xqy");

hubTestX.resetHub();
hubTest.createSimpleMappingProject([
    {
        "relatedEntityMappings": [{
            //"expressionContext": "/contact/",
            "uriExpression": "/customer2.json",
            "targetEntityType": "http://marklogic.com/example/Customer-0.0.1/Customer"
        }]
    }
]);