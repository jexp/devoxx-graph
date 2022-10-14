package org.neo4j;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.inject.Inject;
import javax.ws.rs.Consumes;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import java.util.*;
import org.neo4j.driver.Driver;

@Path("/api")
public class DevoxxResource {

    @Inject Driver driver;

    private static String TALKS_QUERY = """
            MATCH (t:Talk) RETURN t.title as title;
            """;
    @GET
    @Path("/talks")
    @Produces(MediaType.APPLICATION_JSON)
    public List<String> talks() {
        try (var session = driver.session()) {
            return session.run(TALKS_QUERY).list(r -> r.get("title").asString());
        }
    }
}