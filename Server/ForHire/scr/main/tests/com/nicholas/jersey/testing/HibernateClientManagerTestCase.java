package com.nicholas.jersey.testing;

import com.nicholas.jersey.models.Client;
//import com.nicholas.jersey.models.Review;
import com.nicholas.jersey.persistence.*;
import com.nicholas.rest.encrypt.AESEncrypter;

import static org.junit.Assert.*;

import java.util.List;

import org.junit.Before;
import org.junit.Test;

public class HibernateClientManagerTestCase {
	
	@Before
	@Test
	public void testCreatDropTable() {
		HibernateUtil.getCurrentSession();
		assertTrue(HibernateDatabaseClientManager.getDefault().setupTable());
		assertEquals(0, HibernateDatabaseClientManager.getDefault().getNumberOfClients());
		assertTrue(HibernateDatabaseReviewManager.getDefault().setupTable());
		assertEquals(0, HibernateDatabaseReviewManager.getDefault().getNumberOfReviews());
	}
	
	@SuppressWarnings("static-access")
	private String issueToken(String username) throws Exception {
		try {
			AESEncrypter encrypter = AESEncrypter.getDefaultEncrypter();
			return encrypter.encrypt(username);
			
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception("Failed to create encrypted token");
		}
	}
	@Test
	public void testClientTable() throws Exception {
		String[] c1Cat = {"Electrical", "Painting", "Landscaping", "Electronics", "Windows & Doors", "HVAC", "Pools"};
		Client c1 = new Client("arduininicholas@gmail.com", "123456", "4169971958", "Nicholas Arduini", "This is a personal description", c1Cat, "Woodbridge", "Vaughan, ON", "Independent");
		String c1userToken = issueToken(c1.getEmailAddress());
		c1.setUserToken(c1userToken);
		
		String[] c2Cat = {"Electrical", "Electronics"};
		String des2 = "An American billionaire playboy, business magnate, and ingenious engineer, Tony Stark suffers a severe chest injury during a kidnapping in which his captors attempt to force him to build a weapon of mass destruction. He instead creates a powered suit of armor to save his life and escape captivity. Later, Stark augments his suit with weapons and other technological devices he designed through his company, Stark Industries.";
		Client c2 = new Client("1@gmail.com", "123456", "4169971958", "Tony Stark Electrical", des2 , c2Cat, "Stark Tower", "Vaughan, ON", "Buisness");
		String c2userToken = issueToken(c2.getEmailAddress());
		c2.setUserToken(c2userToken);
		
		String[] c3Cat = {"Pools", "HVAC", "Landscaping"};
		String des3 = "Aquaman has been adapted for screen many times, first appearing in animated form in the 1967 The Superman/Aquaman Hour of Adventure and then in the related Super Friends program. Since then he has appeared in various animated productions, including prominent roles in the 2000s series Justice League Unlimited and Batman: The Brave and the Bold, as well as several DC Universe Animated Original Movies. Actor Alan Ritchson also portrayed the role in live action in the television show Smallville. Jason Momoa portrayed the character in the 2016 film Batman v Superman: Dawn of Justice (2016) and will reprise his role in the DC Extended Universe, including a solo film in 2018.";
		Client c3 = new Client("2@gmail.com", "123456", "4169971958", "Auqa Man's Everything Water ", des3, c3Cat, "Pacific Ocean", "Vaughan, ON", "Buisness");
		String c3userToken = issueToken(c3.getEmailAddress());
		c3.setUserToken(c3userToken);
		
		String[] c4Cat = {"Painting", "Landscaping", "Windows & Doors", "Pools"};
		String des4 = "The Punisher is a vigilante who employs murder, kidnapping, extortion, coercion, threats of violence, and torture in his war on crime. Driven by the deaths of his wife and two children, who were killed by the mob for witnessing a killing in New York City's Central Park, the Punisher wages a one-man war on the mob and all criminals in general by using all manner of conventional war weaponry.[3] His family's killers were the first to be slain.[4] A war veteran of the United States Marine Corps, Frank Castle (born Francis Castiglione) is a master of martial arts, stealth tactics, guerrilla warfare, and a wide variety of weapons.";
		Client c4 = new Client("3@gmail.com", "123456", "4169971958", "Frank Castle", des4, c4Cat, "Queens", "Vaughan, ON", "Independent");
		String c4userToken = issueToken(c4.getEmailAddress());
		c4.setUserToken(c4userToken);
		
		String[] c5Cat = {"Landscaping", "Windows & Doors", "HVAC"};
		String des5 = "Phillip Coulson is a character portrayed by American actor Clark Gregg in the films and television series of the Marvel Cinematic Universe (MCU). A high-ranking member of the espionage agency S.H.I.E.L.D., he first appeared in the 2008 film Iron Man, the first film in the MCU. Gregg went on to appear in Iron Man 2 (2010), Thor (2011), and The Avengers (2012). He additionally headlines the television series Agents of S.H.I.E.L.D. (2013–), has appeared in two Marvel One-Shots, and has been featured in multiple tie-in comics, all set in the MCU. The character also appears in other media, including comics published by Marvel Comics.";
		Client c5 = new Client("4@gmail.com", "123456", "4169971958", "Phil Coulson", des5, c5Cat, "Helicarrier", "Vaughan, ON", "Independent");
		String c5userToken = issueToken(c5.getEmailAddress());
		c5.setUserToken(c5userToken);
		
		String[] c6Cat = {"Painting", "Landscaping", "Windows & Doors", "HVAC"};
		String des6 = "Captain America is a fictional superhero appearing in American comic books published by Marvel Comics. Created by cartoonists Joe Simon and Jack Kirby, the character first appeared in Captain America Comics #1 (cover dated March 1941) from Timely Comics, a predecessor of Marvel Comics. Captain America was designed as a patriotic supersoldier who often fought the Axis powers of World War II and was Timely Comics' most popular character during the wartime period. The popularity of superheroes waned following the war and the Captain America comic book was discontinued in 1950, with a short-lived revival in 1953. Since Marvel Comics revived the character in 1964, Captain America has remained in publication.";
		Client c6 = new Client("5@gmail.com", "123456", "4169971958", "Steve Rogers", des6, c6Cat, "Brooklyn", "Vaughan, ON", "Independent");
		String c6userToken = issueToken(c6.getEmailAddress());
		c6.setUserToken(c6userToken);
		
		String[] c7Cat = {"Electrical", "Painting", "Electronics", "HVAC", "Pools"};
		String des7 = "Spider-Man is a fictional superhero appearing in American comic books published by Marvel Comics. The character was created by writer-editor Stan Lee and writer-artist Steve Ditko, and first appeared in the anthology comic book Amazing Fantasy #15 (Aug. 1962) in the Silver Age of Comic Books. Lee and Ditko conceived the character as an orphan being raised by his Aunt May and Uncle Ben, and as a teenager, having to deal with the normal struggles of adolescence in addition to those of a costumed crime-fighter. Spider-Man's creators gave him super strength and agility, the ability to cling to most surfaces, shoot spider-webs using wrist-mounted devices of his own invention, which he calls web-shooters, and react to danger quickly with his spider-sense, enabling him to combat his foes. And later in his life founded his own company call Parker Industries.";
		Client c7 = new Client("6@gmail.com", "123456", "4169971958", "Peter Parker", des7, c7Cat, "Queens", "Vaughan, ON", "Independent");
		String c7userToken = issueToken(c7.getEmailAddress());
		c7.setUserToken(c7userToken);
		
		String[] c8Cat = {"Landscaping", "Electronics", "Windows & Doors", "Pools"};
		String des8 = "Daredevil's origin story relates that while living in the Hell's Kitchen neighborhood of New York City, Matt Murdock is blinded by a radioactive substance that falls from an oncoming vehicle while pushing a man to safety from the oncoming truck. While he no longer can see, the radioactive exposure heightens his remaining senses beyond normal human ability and gives him a radar sense. His father, a boxer named Jack Murdock, supports him as he grows up, though Jack is later killed by gangsters after refusing to throw a fight. After donning a yellow and dark red costume (later all dark red), Matt seeks out revenge against his father's killers as the superhero Daredevil, fighting against his many enemies, including Bullseye and Kingpin.[2] He also becomes a lawyer. Daredevil is also commonly known by such epithets as the Man Without Fear[3] and the Devil of Hell's Kitchen.";
		Client c8 = new Client("7@gmail.com", "123456", "4169971958", "Matthew Murdock", des8, c8Cat, "Hell's Kitchen", "Vaughan, ON", "Independent");
		String c8userToken = issueToken(c8.getEmailAddress());
		c8.setUserToken(c8userToken);
		
		String[] c9Cat = {"Painting", "Electronics", "HVAC", "Pools"};
		String des9 = "The Hulk is a fictional superhero created by writer Stan Lee and artist Jack Kirby, who first appeared in the debut issue of the comic book The Incredible Hulk in May 1962 published by Marvel Comics. In his comic book appearances, the character is both the Hulk, a green-skinned, hulking and muscular humanoid possessing a vast degree of physical strength, and his alter ego Bruce Banner, a physically weak, socially withdrawn, and emotionally reserved physicist, the two existing as personalities independent and resenting of the other.";
		Client c9 = new Client("8@gmail.com", "123456", "4169971958", "Bruce Banner", des9, c9Cat, "Planet Hulk", "Vaughan, ON", "Independent");
		String c9userToken = issueToken(c9.getEmailAddress());
		c9.setUserToken(c9userToken);
		
		String[] c10Cat = {"Painting", "Electronics", "Windows & Doors", "HVAC"};
		String des10 = "Scott Lang was an ex-convict and electronics expert hired by Stark International, which enabled him to steal the Ant-Man suit from Hank Pym who had long since given up the name. Lang stole the suit to help his sick daughter, which, when Pym found out, caused Pym to give the suit to Scott, allowing him to become the second Ant-Man. As Ant-Man he served as an Avenger for years, until he was killed during the Avengers Disassembled storyline. Years later he was resurrected in the Avengers: The Children's Crusade mini series. Following his resurrection, Lang was briefly the head of the Future Foundation.";
		Client c10 = new Client("9@gmail.com", "123456", "4169971958", "Scott Lang", des10, c10Cat, "Ant hill", "Vaughan, ON", "Independent");
		String c10userToken = issueToken(c10.getEmailAddress());
		c10.setUserToken(c10userToken);
		
		String[] c11Cat = {"Painting", "Landscaping", "Electronics", "Windows & Doors", "HVAC"};
		String des11 = "The character played a role in the crossover comic book storylines Annihilation (2006) and Annihilation: Conquest (2007), and became the leader of the space-based superhero team Guardians of the Galaxy in the 2008 relaunch of the comic of the same name. He has been featured in a variety of associated Marvel merchandise, including animated television series, toys, and trading cards. Chris Pratt portrays the character in the 2014 live-action film Guardians of the Galaxy.";
		Client c11 = new Client("10@gmail.com", "123456", "4169971958", "Peter Quill", des11, c11Cat, "Ant hill", "Vaughan, ON", "Independent");
		String c11userToken = issueToken(c11.getEmailAddress());
		c11.setUserToken(c11userToken);
		
		
		String[] cCat = {"Painting", "Landscaping", "Electronics", "Windows & Doors", "HVAC", "Pools"};
		Client c = new Client("ni@gmail.com", "123456", "4169971958", "Everything TO", "Description", cCat, "Pacific Ocean", "Toronto, ON", "Buisness");
		String cuserToken = issueToken(c.getEmailAddress());
		c.setUserToken(cuserToken);
		
		assertTrue(HibernateDatabaseClientManager.getDefault().add(c1));
		assertTrue(HibernateDatabaseClientManager.getDefault().add(c2));
		assertTrue(HibernateDatabaseClientManager.getDefault().add(c3));
		assertTrue(HibernateDatabaseClientManager.getDefault().add(c4));
		assertTrue(HibernateDatabaseClientManager.getDefault().add(c5));
		assertTrue(HibernateDatabaseClientManager.getDefault().add(c6));
		assertTrue(HibernateDatabaseClientManager.getDefault().add(c7));
		assertTrue(HibernateDatabaseClientManager.getDefault().add(c8));
		assertTrue(HibernateDatabaseClientManager.getDefault().add(c9));
		assertTrue(HibernateDatabaseClientManager.getDefault().add(c10));
		assertTrue(HibernateDatabaseClientManager.getDefault().add(c11));
		assertTrue(HibernateDatabaseClientManager.getDefault().add(c));
		
		
		Client dataBaseClient = HibernateDatabaseClientManager.getDefault().getClientByEmailAddress(c1.getEmailAddress());
		assertEquals(dataBaseClient.getEmailAddress(), c1.getEmailAddress());
		
		List<Client> vaughanClients = HibernateDatabaseClientManager.getDefault().getClientsByRegionAndCategory("Vaughan, ON", "Electrical");
		for(int i = 0; i < vaughanClients.size(); i++){
			if(vaughanClients.get(i).getReviews().size() > 0){
				System.out.println(vaughanClients.get(i).getReviews().get(0).getReviewText());
			}
		}
		
		assertEquals(0, HibernateDatabaseReviewManager.getDefault().getNumberOfReviews());
	}
	
	
}
