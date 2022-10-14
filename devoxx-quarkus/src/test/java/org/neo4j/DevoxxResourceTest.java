package org.neo4j;

import io.quarkus.test.junit.QuarkusTest;
import org.junit.jupiter.api.Test;

import static io.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.*;

@QuarkusTest
public class DevoxxResourceTest {

    @Test
    public void testHelloEndpoint() {
        given()
          .when().get("/api/talks")
          .then()
             .statusCode(200)
             .body(containsString("Spring"));
    }

}