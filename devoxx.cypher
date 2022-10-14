create constraint speaker_id for (sp:Speaker) require (sp.id) is unique;
create constraint talk_id for (t:Talk) require (t.id) is unique;
create constraint tag_id for (t:Tag) require (t.name) is unique;
create constraint track_id for (t:Track) require (t.id) is unique;

call apoc.load.json("https://dvbe22.cfp.dev/api/public/speakers") yield value as row
merge (sp:Speaker {id:row.id})
on create set sp.name = row.fullName, sp.company = row.company, sp.image = row.imageUrl, sp.twitter = row.twitterHandle;


call apoc.load.json("https://dvbe22.cfp.dev/api/public/talks") yield value as row
with row where not row.sessionType.isPause
merge (t:Talk {id:row.id})
on create set t.title = row.title, t.summary = row.summary, t.level = row.audienceLevel,
t.duration = row.sessionType.duration, t.type = row.sessionType.name

merge (tr:Track {id:row.track.id}) on create set tr.name = row.track.name, tr.description = row.track.description
merge (t)-[:IN_TRACK]->(tr)

with * 
unwind row.speakers as speaker
merge (sp:Speaker {id:speaker.id})
on create set sp.name = speaker.fullName, sp.company = speaker.company, sp.image = speaker.imageUrl, sp.twitter = speaker.twitterHandle
merge (sp)-[:PRESENTS]->(t)

with distinct row, t
unwind row.tags as tag
merge (tg:Tag {name:tag.name})
merge (t)-[:TAGGED]->(tg);

https://dvbe22.cfp.dev/api/public/rooms

{
"id": 4703,
"name": "Exhibition Hall",
"weight": 1,
"capacity": 2000
},

https://dvbe22.cfp.dev/api/public/tracks


MERGE (r:Room {id:row.room.id})
ON CREATE SET r.name = row.room.name, r.capacity = row.room.capacity

SET t.start = datetime(row.fromDate), t.end = datetime(row.toDate), 

row.proposal as talk
talk.track, talk.speakers, talk.sessionType, talk.topics

SET t.favorites = row.totalFavourites

call apoc.load.json("https://dvbe22.cfp.dev/api/public/schedules") yield value
unwind value.links as day

call apoc.load.json(day.href) yield value as row

with row, row.proposal as talkData where not talkData.sessionType.isPause

MERGE (r:Room {id:row.room.id})
ON CREATE SET r.name = row.room.name, r.capacity = row.room.capacity

merge (t:Talk {id:talkData.id})
on create set t.title = talkData.title, t.summary = talkData.summary, t.level = talkData.audienceLevel,
t.duration = talkData.sessionType.duration, t.type = talkData.sessionType.name

SET t.favorites = row.totalFavourites, t.start = datetime(row.fromDate), t.end = datetime(row.toDate)

merge (t)-[:IN_ROOM]->(r)

merge (tr:Track {id:talkData.track.id}) on create set tr.name = talkData.track.name, tr.description = talkData.track.description
merge (t)-[:IN_TRACK]->(tr)

with * 
unwind talkData.speakers as speaker
merge (sp:Speaker {id:speaker.id})
on create set sp.name = speaker.fullName, sp.company = speaker.company, sp.image = speaker.imageUrl, sp.twitter = speaker.twitterHandle
merge (sp)-[:PRESENTS]->(t)

with distinct talkData, t
unwind talkData.tags as tag
merge (tg:Tag {name:tag.name})
merge (t)-[:TAGGED]->(tg);


"fromDate": "2022-10-10T07:30:00Z",
"toDate": "2022-10-10T10:30:00Z",

{
"id": 4810,
"fromDate": "2022-10-10T07:30:00Z",
"toDate": "2022-10-10T10:30:00Z",
"overflow": false,
"reserved": null,
"remark": null,
"eventId": 1151,
"eventName": "Devoxx Belgium 2022",
"room": {
"id": 4706,
"name": "Room 4",
"weight": 4,
"capacity": 348
},
"streamId": null,
"sessionType": {
"id": 959,
"name": "Deep Dive",
"duration": 180,
"isPause": false,
"description": "3 hours sessions where attendees can rapidly immerse themselves in a subject matter with an in-depth examination of a topic or technology.",
"cssColor": null
},
"track": null,
"proposal": {
"id": 16122,
"title": "A Java developer Journey into Apache Cassandra™",
"description": "<p>Apache Cassandra™ is a distributed NoSQL distributed database deployed extensively at web giants like Apple, Netflix or Uber.</p><p><br></p><p>During this deep-dive session, we will give you everything you need to master this technology: from architecture to data modeling, from drivers to best practices. Through practical labs requiring no installation, we will browse and run applications implemented with Spring Boot, Quarkus, and Micronaut in order to see how Apache Cassandra™ can be used in modern java applications. Take home 3 working projects at home.</p>",
"summary": null,
"afterVideoURL": null,
"audienceLevel": "INTERMEDIATE",
"track": {
"id": 1252,
"name": "Data & AI",
"description": "Big Data, NoSQL, Machine learning, Deep Learning, Neural Networks, TensorFlow, etc",
"imageURL": "https://s3-eu-west-1.amazonaws.com/voxxeddays/webapp/images/e80e14f1-7a23-4a6d-a955-7a653973f6eb.png"
},
"sessionType": {
"id": 959,
"name": "Deep Dive",
"duration": 180,
"isPause": false,
"description": "3 hours sessions where attendees can rapidly immerse themselves in a subject matter with an in-depth examination of a topic or technology.",
"cssColor": null
},
"speakers": [
{
"id": 16071,
"firstName": "Cedrick",
"lastName": "Lunven",
"fullName": "Cedrick Lunven",
"bio": "<p class=\"ql-align-justify\"><span style=\"color: rgb(21, 27, 30);\">Cedrick leads the Developer Advocate Team at Datastax. Speaker, and trainer he is firstly a passionate java developer and implements products CLI and SDKs. In 2013 he created the open-source feature toggle library called </span><em style=\"color: rgb(21, 27, 30);\">FF4J</em><span style=\"color: rgb(21, 27, 30);\"> which he has been actively maintaining. With 15 years in the industry as a tech leach, solution architect, or presales he can discuss a wide range of technologies and architectures.&nbsp;</span></p><p><br></p><p><br></p>",
"company": "DataStax",
"imageUrl": "https://devoxxian-image-thumbnails.s3-eu-west-1.amazonaws.com/profile-4a1db4b4-4467-44c4-826a-d56da4422c1f.png",
"twitterHandle": "@clunven"
}
],
"tags": [
{
"name": "Quarkus"
},
{
"name": "NoSQL"
},
{
"name": "Micronaut"
},
{
"name": "Spring"
},
{
"name": "Cloud Native Java"
}
],
"timeSlots": []
},
"audienceLevel": null,
"langName": null,
"timezone": "Europe/Paris",
"speakers": [],
"tags": [],
"totalFavourites": 89
},

sp.image = row.imageUrl, sp.twitter = row.twitterHandle;

audienceLevel

https://dvbe22.cfp.dev/api/public/talks

{
"id": 57558,
"firstName": "Adriano",
"lastName": "Campestrini",
"fullName": "Adriano Campestrini",
"bio": "<p><span style=\"background-color: transparent; color: rgb(0, 0, 0);\">Adriano is a Service Delivery Manager at ARHS in Luxembourg currently helping the digital transformation in the financial sector. Passionate about software engineering and how we organise to build it, he accumulates experiences from having lived in 3 continents and from applying XP/Scrum/Lean/Kanban ever since (2003) Agile was far from the mainstream.</span></p>",
"company": "ARHS",
"imageUrl": "https://devoxxian-image-thumbnails.s3-eu-west-1.amazonaws.com/profile-740ea99d-0fcf-4bb8-be16-2f9bec9dd261.jpg",
"twitterHandle": ""
},


{
"id": 49652,
"title": "2022: A GitOps Odyssey",
"description": "<p><span style=\"color: rgb(0, 0, 0);\">We all remember our very first Kubernetes cluster, right? Carefully installing all kinds of awesome things!</span></p><p><span style=\"color: rgb(0, 0, 0);\">Prometheus, Grafana, Loki you know the drill! Maybe even installing some more exotic stuff, external-dns, cert-manager and so on!</span></p><p><br></p><p><span style=\"color: rgb(0, 0, 0);\">It's an awesome feeling installing all these components and just watching all the pods pop up granting you endless possibilities!</span></p><p><br></p><p><span style=\"color: rgb(0, 0, 0);\">However, we should make sure cluster configuration stays fun, even at scale. That's the mission of this session!</span></p><p><span style=\"color: rgb(0, 0, 0);\">Using GitOps as the foundation we will tackle scaling cluster configuration whilst also keeping an eye out for topics like multi-tenancy and being cloud agnostic.</span></p>",
"summary": null,
"afterVideoURL": null,
"audienceLevel": "BEGINNER",
"track": {
"id": 1254,
"name": "Build & Deploy",
"description": "Modern operational concerns, including build pipelines, orchestration, observability, monitoring, resilience, and compliance, as the software world embraces DevOps and cloud delivery.",
"imageURL": "https://devoxx-tracks.s3.eu-west-1.amazonaws.com/Build-Deploy-no-text.png"
},
"sessionType": {
"id": 951,
"name": "Conference",
"duration": 50,
"isPause": false,
"description": "Tech sessions of 50 minutes on a range of different technologies, practices and methodologies.",
"cssColor": null
},
"speakers": [
{
"id": 49403,
"firstName": "Robin",
"lastName": "De Roeck",
"fullName": "Robin De Roeck",
"bio": "<p>DevOps Engineer at Sofico</p>",
"company": "Sofico",
"imageUrl": "https://devoxxian-image-thumbnails.s3-eu-west-1.amazonaws.com/profile-bf615f53-0fef-4644-aec4-19d02b719855.jpg",
"twitterHandle": ""
}
],
"tags": [
{
"name": "Kubernetes"
},
{
"name": "GitOps"
},
{
"name": "cluster management"
}
],
"timeSlots": []
},