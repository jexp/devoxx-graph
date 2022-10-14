package org.neo4j;

import org.neo4j.driver.Driver;
import io.micronaut.http.annotation.*;
import java.util.*;

interface DevoxxController {
    @Get("/talks")
    public List<String> talks();

    @Get("/talks/{speaker}")
    public List<String> talksForSpeaker(String speaker);
}

