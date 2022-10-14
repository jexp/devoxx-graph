package org.neo4j;

import org.neo4j.driver.Driver;
import io.micronaut.http.annotation.*;
import java.util.*;

@Controller("/api")
public class DevoxxControllerImpl implements DevoxxController {

    private final Driver driver;
    public DevoxxControllerImpl(Driver driver) {
        this.driver = driver;
    }

    public List<String> talks() {
        try (var session = driver.session()) {
            return session
                    .run("MATCH (t:Talk) RETURN t.title as title")
                    .list(r -> r.get("title").asString());
        }
    }

    public List<String> talksForSpeaker(String speaker) {
        try (var session = driver.session()) {
            var query = """
MATCH (sp:Speaker)-[:PRESENTS]->(t:Talk) 
WHERE sp.name contains $name 
RETURN t.title as title
            """;
            return session
                    .run(query, Map.of("name",speaker))
                    .list(r -> r.get("title").asString());
        }
    }

}