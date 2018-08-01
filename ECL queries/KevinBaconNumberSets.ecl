
IMPORT Std;
IMPORT $ AS test;

EXPORT KevinBaconNumberSets := MODULE
 
  NameMatch(string full_name, string fname,string lname) :=
    Std.Str.Find(full_name,fname,1) > 0 AND 
    Std.Str.Find(full_name,lname,1) > 0;

	AllKBEntries := test.ActorsInMovies(NameMatch(actor,'Kevin','Bacon'));
  EXPORT KBMovies := DEDUP(AllKBEntries, movie, ALL); 
	EXPORT KBMoviesNew := DISTRIBUTE(KBMovies,SKEW(0.1,0.5));

  CoStars := test.ActorsInMovies(Movie IN SET(KBMovies,Movie));
  EXPORT KBCoStars := DEDUP( CoStars(actor<>'Kevin Bacon'), actor, ALL);
	EXPORT KBCoStarsnew := DISTRIBUTE(KBCoStars,SKEW(0.1,0.5));
    CSM := DEDUP(JOIN(test.ActorsInMovies,KBCoStarsnew, LEFT.actor=RIGHT.actor,
                    TRANSFORM(LEFT), LOOKUP),
               movie,ALL);
  EXPORT KBCoStarMovies := CSM(movie NOT IN SET(KBMoviesnew,movie));
	EXPORT KBCoStarMoviesnew := DISTRIBUTE(KBCoStarMovies,SKEW(0.1,0.5));
 
  KBCo2S := DEDUP(JOIN(test.ActorsInMovies, KBCoStarMoviesnew, LEFT.movie=RIGHT.movie,
                       TRANSFORM(LEFT), LOOKUP),
                  actor, ALL);

  EXPORT KBCo2Stars := JOIN(KBCo2S, KBCoStarsnew, LEFT.actor=RIGHT.actor, TRANSFORM(LEFT), LEFT ONLY);
	EXPORT KBCo2Starsnew := DISTRIBUTE(KBCo2Stars,SKEW(0.1,0.5));

  Co2SM := DEDUP(JOIN(test.ActorsInMovies, KBCo2Starsnew, LEFT.actor=RIGHT.actor,
                      TRANSFORM(LEFT), LOOKUP),
                 movie, ALL);

  Export KBCo2StarMovies := JOIN(Co2SM, KBCoStarMoviesnew, LEFT.movie=RIGHT.movie,
                                 TRANSFORM(LEFT),LEFT ONLY);
	EXPORT KBCo2StarMoviesnew := DISTRIBUTE(KBCo2StarMovies,SKEW(0.1,0.5));

  KBCo3S := DEDUP(JOIN(test.ActorsInMovies, KBCo2StarMoviesnew, LEFT.movie=RIGHT.movie,
                       TRANSFORM(LEFT), LOOKUP),
                  actor, ALL);

  EXPORT KBCo3Stars := JOIN(KBCo3S, KBCo2Starsnew, LEFT.actor=RIGHT.actor, 
                            TRANSFORM(LEFT),LEFT ONLY);
	EXPORT KBCo3Starsnew := DISTRIBUTE(KBCo3Stars,SKEW(0.1,0.5));
 
  Co3SM := DEDUP(JOIN(test.ActorsInMovies, KBCo3Starsnew, LEFT.actor=RIGHT.actor,
                      TRANSFORM(LEFT), LOOKUP),
                 movie, ALL);

  EXPORT KBCo3StarMovies := JOIN(Co3SM, KBCo2StarMoviesnew, LEFT.movie=RIGHT.movie,
                                 TRANSFORM(LEFT),LEFT ONLY);
	EXPORT KBCo3StarMoviesnew := DISTRIBUTE(KBCo3StarMovies,SKEW(0.1,0.5));

  KBCo4S := DEDUP(JOIN(test.ActorsInMovies, KBCo3StarMoviesnew, LEFT.movie=RIGHT.movie,
                       TRANSFORM(LEFT), LOOKUP),
                  actor, ALL);

  EXPORT KBCo4Stars := JOIN(KBCo4S, KBCo3Starsnew, LEFT.actor=RIGHT.actor,
                            TRANSFORM(LEFT),LEFT ONLY);
	EXPORT KBCo4Starsnew := DISTRIBUTE(KBCo4Stars,SKEW(0.1,0.5));


  Co4SM := DEDUP(JOIN(test.ActorsInMovies, KBCo4Starsnew, LEFT.actor=RIGHT.actor,
                      TRANSFORM(LEFT), LOOKUP),
                 movie, ALL);

  EXPORT KBCo4StarMovies := JOIN(Co4SM, KBCo3StarMoviesnew, LEFT.movie=RIGHT.movie,
                                 TRANSFORM(LEFT),LEFT ONLY);
	EXPORT KBCo4StarMoviesnew := DISTRIBUTE(KBCo4StarMovies,SKEW(0.1,0.5));

  KBCo5S := DEDUP(JOIN(test.ActorsInMovies, KBCo4StarMoviesnew, LEFT.movie=RIGHT.movie,
                       TRANSFORM(LEFT), LOOKUP),
                  actor, ALL);

  EXPORT KBCo5Stars := JOIN(KBCo5S, KBCo4Starsnew, LEFT.actor=RIGHT.actor, TRANSFORM(LEFT),LEFT ONLY);
	EXPORT KBCo5Starsnew := DISTRIBUTE(KBCo5Stars,SKEW(0.1,0.5));

  Co5SM := DEDUP(JOIN(test.ActorsInMovies, KBCo5Starsnew, LEFT.actor=RIGHT.actor,
                      TRANSFORM(LEFT), LOOKUP),
                 movie,ALL);

  EXPORT KBCo5StarMovies := JOIN(Co5SM, KBCo4StarMoviesnew, LEFT.movie=RIGHT.movie,
                                 TRANSFORM(LEFT),LEFT ONLY);
	EXPORT KBCo5StarMoviesnew := DISTRIBUTE(KBCo5StarMovies,SKEW(0.1,0.5));


  KBCo6S  := DEDUP(test.ActorsInMovies(movie IN SET(KBCo5StarMoviesnew, movie)),
                   actor, ALL);

  EXPORT KBCo6Stars := JOIN(KBCo6S, KBCo5Starsnew, LEFT.actor=RIGHT.actor,
                            TRANSFORM(LEFT),LEFT ONLY);
	EXPORT KBCo6Starsnew := DISTRIBUTE(KBCo6Stars,SKEW(0.1,0.5));

  Co6SM := DEDUP(test.ActorsInMovies(actor IN SET(KBCo6Starsnew, actor)), movie, ALL);

  EXPORT KBCo6StarMovies := Co6SM(movie NOT IN SET(KBCo5StarMoviesnew, movie));
	EXPORT KBCo6StarMoviesnew := DISTRIBUTE(KBCo6StarMovies,SKEW(0.1,0.5));
 
  KBCo7S := DEDUP(test.ActorsInMovies(movie IN SET(KBCo6StarMoviesnew,movie)), actor, ALL);
  EXPORT KBCo7Stars := KBCo7S(actor NOT IN SET(KBCo6Starsnew, actor));
	EXPORT KBCo7Starsnew := DISTRIBUTE(KBCo7Stars,SKEW(0.1,0.5));

  EXPORT doCounts := PARALLEL(
    OUTPUT(COUNT(KBMovies), NAMED('KBMovies')),
    OUTPUT(COUNT(KBCoStars), NAMED('KBCoStars')),
    OUTPUT(COUNT(KBCoStarMovies), NAMED('KBCoStarMovies')),
    OUTPUT(COUNT(KBCo2Stars), NAMED('KBCo2Stars')),
    OUTPUT(COUNT(KBCo2StarMovies), NAMED('KBCo2StarMovies')),
    OUTPUT(COUNT(KBCo3Stars), NAMED('KBCo3Stars')),
    OUTPUT(COUNT(KBCo3StarMovies), NAMED('KBCo3StarMovies')),
    OUTPUT(COUNT(KBCo4Stars), NAMED('KBCo4Stars')),
    OUTPUT(COUNT(KBCo4StarMovies), NAMED('KBCo4StarMovies')),
    OUTPUT(COUNT(KBCo5Stars), NAMED('KBCo5Stars')),
    OUTPUT(COUNT(KBCo5StarMovies), NAMED('KBCo5StarMovies')),
    OUTPUT(COUNT(KBCo6Stars), NAMED('KBCo6Stars')),
    OUTPUT(COUNT(KBCo6StarMovies), NAMED('KBCo6StarMovies')),
    OUTPUT(COUNT(KBCo7Stars), NAMED('KBCo7Stars')),
    OUTPUT(KBCo7Stars)
  );

END;

