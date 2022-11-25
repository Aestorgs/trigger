CREATE TABLE users(id SERIAL PRIMARY KEY , name text NOT NULL , age integer NOT NULL , createdat date );
 
INSERT INTO users(id , name , age  ) values(1 , 'pierre' , 20 );
INSERT INTO users(id , name , age  ) values(2 , 'jean' , 19 );
INSERT INTO users(id , name , age  ) values(3 , 'françois' , 18 );
INSERT INTO users(id , name , age  ) values(4 , 'louis' , 17 );
INSERT INTO users(id , name , age  ) values(5 , 'jaques' , 16 );
INSERT INTO users(id , name , age  ) values(6 , 'denis' , 15 );

DROP FUNCTION public.users() CASCADE ;
DROP FUNCTION public.age() CASCADE ;

DELETE FROM "users";

/*****crée un trigger pour date pour inserer automatique la date *****/

CREATE FUNCTION public.users() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
	NEW.createdat = NOW();
	RETURN coalesce(NEW , OLD );
END;
$$;


CREATE TRIGGER dateTrigger BEFORE INSERT ON public.users FOR EACH ROW EXECUTE FUNCTION public.users();


/*****crée un trigger pour age pour dire que c'est que pour les 18 ans sinon suprime si il a 17 ans *****/

CREATE FUNCTION public.age() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
	output TEXT;
BEGIN
    DELETE FROM users where age <= 17;
    CASE 
		WHEN NEW.age >= 18  THEN output := 'yes you are 18';
        WHEN NEW.age <= 17  THEN output := 'no you are not 18';
        ELSE output := 'erreur problem';
	END CASE;
	raise notice '%', output ;
	RETURN coalesce(NEW, OLD);
END;
$$;

CREATE TRIGGER ageTrigger AFTER INSERT ON public.users FOR EACH ROW EXECUTE FUNCTION public.age();
