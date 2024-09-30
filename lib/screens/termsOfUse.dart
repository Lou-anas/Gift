import 'package:flutter/material.dart';

class Termsofuse {
  static void showTermsOfUseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Règlement Du Jeu Concours"),
          content: SingleChildScrollView(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(color: Colors.black), // Default text style
                children: [
                  TextSpan(
                    text:
                        'Règlement Du jeu concours\nScratch & Win Budweiser®\nLa société BOURCHANIN ET CIE\n\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'ARTICLE 1 – OBJET\n\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        '  BOURCHANIN ET CIE, société anonyme au capital de 51 000.000.000 de dirhams, dont le siège social est sis à Casablanca, BD Ahl Loghlam Sidi Moumen – Casablanca, inscrite au registre du commerce de Casablanca sous le numéro 2213, représentée aux fins des présentes par M. HICHAM RKHA, agissant en sa qualité de Directeur Général en vertu des pouvoirs qui lui ont été conférés à cet effet (« Bourchanin et Cie »), organise un jeu concours sous la dénomination « Budweiser»  (Ci-après la « Jeu concours» ) durant la période allant du  14 Octobre 2024 au 11 Novembre 2024.\n\n',
                  ),
                  TextSpan(
                    text: 'ARTICLE 2 – CONDITIONS DE PARTICIPATION\n\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        '  Pour participer au jeu concours, le participant (le « Participant ») doit :\n\n'
                        '    • Être majeur, de toute nationalité confondue\n'
                        '    • Effectué un achat d’un seau du produit Budweiser®, donne la possibilité de participer à notre Jeu concours\n'
                        '    • Remplir son prénom et son numéro de téléphone est obligatoire\n\n'
                        '  La validation des conditions de participation est obligatoire via l’onglet tactile sur tablette\n\n'
                        '  La participation est valide dans la limite de la date de fin de validité marquée à l’article 1.\n\n'
                        '  En cas de manquement de la part d’un Participant aux conditions ci-dessus, la société Bourchanin et Cie se réserve la faculté d’écarter de plein droit sa participation, sans que celui-ci ne puisse revendiquer quoi que ce soit.\n\n'
                        '  Les Participants autorisent, sauf avis contraire, toute exploitation promotionnelle interne ou externe qui pourrait être faite par la société Bourchanin et Cie de leur nom, prénom, sans prétendre à d’autre droit ou rémunération que le lot leur revenant. Cette autorisation est valable pour tout support connu ou inconnu à ce jour, pour tout moyen de communication et pour une durée d’un (1) an à compter de la date du début du jeu concours.\n\n',
                  ),
                  TextSpan(
                    text: 'ARTICLE 3 – EXCLUSION ET AUTORISATIONS\n\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        '  Sont inclus à la participation au présent jeu concours, les collaborateurs et collaboratrices de la société « la société Bourchanin et Cie » organisatrice de ce jeu concours. La restriction s’applique à l’Huissier de Justice qui assure le déroulement du tirage au sort.\n\n'
                        '  Si un ou plusieurs Participants deviennent collaborateurs de « la société Bourchanin et Cie » pendant le jeu concours, ce Participant pourra réclamer les lots dans l’hypothèse où il serait déclaré gagnant.\n\n'
                        '  Dans cette hypothèse, la société Bourchanin et Cie pourra attribuer de plein droit les lots de gain au gagnant.\n\n',
                  ),
                  TextSpan(
                    text: 'ARTICLE 4 – TIRAGE AU SORT\n\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        '  La participation au tirage du jeu concours est conditionnée par l’achat d’un seau Budweiser®\n\n'
                        '  Toute participation incomplète pourra être rejetée ou non prise en compte lors du tirage au sort.\n\n'
                        '  La société Bourchanin et Cie se réserve le droit de considérer comme non valide toute inscription avec un contenu farfelu.\n\n'
                        '  Il est rappelé que dans un souci de transparence dans le jeu concours digital, les Participants doivent fournir des informations identiques à leurs données personnelles (prénoms, numéro de téléphone, …), la société Bourchanin et Cie se réserve le droit de s’assurer de la véracité de ces informations à tout moment.\n\n'
                        '  Un tirage aux sorts sera effectué, à la fin du jeu concours, au siège de la société, en présence et sous le contrôle d’un Huissier de Justice assermenté pour faire gagner cinq (5) participants, 50 seaux Budweiser® sous forme de tickets.\n\n'
                        '  Le tirage aux sorts sera effectué sous le contrôle d’un Huissier de Justice le 11 novembre 2024.\n\n'
                        '  Chaque participation est nominative et ne peut faire l’objet d’un transfert à qui que ce soit.\n\n'
                        '  Toute personne tirée au sort, pour lequel le gagnant aura été contacté par message sans succès, sera éliminé. Un nouveau tirage au sort sera effectué. Par voie de conséquences, toute réclamation ultérieure de quelque nature qu’elle soit sera irrecevable.\n\n'
                        '  Le tirage au sort fera l’objet d’un procès-verbal signé par les représentants, habilités, et en présence d’un Huissier de Justice.\n\n',
                  ),
                  TextSpan(
                    text: 'ARTICLE 5 – TRANSMISSION DES LOTS\n\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        '  Le gagnant du jeu concours recevra son lot sous la supervision du KCM affecté à la région.\n\n'
                        '  Le lot lui sera remis à partir de la première semaine qui suit l’annonce des gagnants, à compter de ce délai les gagnants auront un délai maximum de trente (30) jours pour récupérer leurs tickets.\n\n'
                        '  En aucun cas, la contrepartie en espèces des tickets ne pourra être exigée ni le remplacement ou l’échange du lot pour quelque cause que ce soit.\n\n',
                  ),
                  TextSpan(
                    text: 'ARTICLE 6 – PROPRIETE INTELLECTUELLE\n\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        '  La reproduction, la représentation ou l’exploitation de tout ou d’une partie des éléments composants le jeu concours qui y sont proposés sont strictement interdites. Tous les concepts, logos, marques, noms produits par la société Bourchanin et Cie restent sa propriété exclusive.\n\n',
                  ),
                  TextSpan(
                    text: 'ARTICLE 7 – TRAITEMENT DES DONNÉES PERSONNELLES\n\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        '  Les Participants reconnaissent et acceptent que les données collectées, dans le cadre du présent jeu concours, objet des présentes, fassent l’objet d’un traitement informatique. Elles sont utilisées par «la société Bourchanin et Cie » ou ses prestataires pour la gestion de leur propre compte et, le cas échéant, pour toute opération de marketing directe, quel que soit le média utilisé, réalisée par « la société Bourchanin et Cie » pour informer ses clients de tous ses offres et services.\n\n'
                        '  Aussi, les Participants autorisent « la société Bourchanin et Cie », par leur simple participation au jeu concours objet des présentes, à utiliser leur nom, prénom afin de leur demander de participer aux futurs jeux concours ou jeux organisés par elle.\n\n'
                        '  Conformément à loi 09-08 relative à « la protection des personnes physiques à l’égard du traitement des données à caractère personnel », chaque personne Participante dispose à tout moment d’un droit individuel d’accès ainsi que d’un droit d’information complémentaire, de rectification des données le concernant et, le cas échéant, d’opposition au traitement de ses données ou à leur transmission par « BOURCHANIN ET CIE » à des tiers.\n\n'
                        '  Il peut exercer ses droits en envoyant un courrier, mentionnant ses : nom, prénom et en y joignant une copie de sa pièce d’identité, à l’adresse suivante : BD Ahl Loghlam Sidi Moumen – Casablanca.\n\n',
                  ),
                  TextSpan(
                    text:
                        'ARTICLE 8 : AUTORISATION / CESSION DE DROITS D’IMAGE\n\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                      text:
                          '  La Société Organisatrice se réservent la faculté de donner, lors des opérations de tirage au sort, à leur issue, comme postérieurement à celles-ci, les dimensions publicitaires qu’elle pourra éventuellement juger opportunes.\n\n'
                          '  Cela implique que le participant en a connaissance et accepte que son éventuelle qualité de gagnant, son image, sa publication, son nom, prénom puissent faire l’objet d’une publicité par voie de tout support écrit, visuel, Internet, radiophonique ou audiovisuel, sans que cette utilisation ne lui confère une rémunération ou un droit ou avantage quelconque, que le gagnant reconnait et accepte.\n\n'),
                  TextSpan(
                    text: 'ARTICLE 9 : FRAUDES \n\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                      text:
                          '  La société Bourchanin et Cie pourra annuler tout ou partie du jeu concours s’il apparaît que des fraudes sont intervenues sous quelques formes que ce soit, notamment de manière informatique dans le cadre de la participation au présent jeu concours ou de la détermination des gagnants.\n\n'
                          '  Elle se réserve, dans cette hypothèse, le droit de ne pas attribuer les dotations aux fraudeurs et/ou de poursuivre devant les juridictions compétentes les auteurs de ces fraudes.\n\n'),
                  TextSpan(
                    text: 'ARTICLE 10 : CONFIDENTIALITE \n\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                      text:
                          '  Les personnes chargées de l’organisation du présent règlement du jeu concours sont tenues par la confidentialité quant aux données personnelles collectées au cours du déroulement du jeu concours jusqu\'à la proclamation des résultats par le comité d\'organisation.\n\n'),
                  TextSpan(
                    text: 'ARTICLE 11 : ACCEPTATION DU PRESENT REGLEMENT  \n\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                      text:
                          '  La Participation au jeu concours implique l’acceptation pleine et entière du présent règlement.\n\n'
                          '  Tout contrevenant à l’un ou plusieurs des articles du présent règlement sera privé de participation.\n\n'
                          '  La société Bourchanin et Cie se réserve le droit de suspendre, proroger, différer, écourter, modifier ou d’annuler sans préavis le jeu concours objet des présentes, si les circonstances l’exigeaient. Sa responsabilité ne saurait être engagée à ce titre.\n\n'
                          '  Toutes difficultés pratiques d’interprétation ou d’application non prévues par le règlement seront tranchées souverainement par la société organisatrice « la société Bourchanin et Cie ».\n\n'
                          '  Les Participants au présent jeu concours dégagent la société Bourchanin et Cie de toute responsabilité quant à tout dommage de quelque nature que ce soit, pouvant résulter directement ou indirectement à la suite de leur participation à cette dernière.\n\n'),
                  TextSpan(
                    text:
                        'ARTICLE 12 :  MODIFICATION, REPORT OU ANNULATION DU CONCOURS \n\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                      text:
                          '  Dans le cas où une modification des schémas et mécanismes du jeu concours pourrait s’avérer nécessaire notamment en cas de force majeure ou de changement des dispositions légales, il sera procédé à la mise à jour corrélative du présent règlement.\n\n'
                          '  Dans ce cas, aucune indemnité ne pourra être réclamée de ce fait à la société Bourchanin et Cie.\n\n'
                          '  La société Bourchanin et Cie se réserve le droit de reporter ou annuler le jeu concours à tout moment, sans préavis et à sa seule discrétion, sans que cette décision ne donne droit à une indemnisation de quelque nature que ce soit au bénéfice de tout partenaire ou sponsor, tout Participant ou tout tiers.\n\n'
                          '  Le cas échéant, la société Bourchanin et Cie en informera valablement les Participants via une insertion sur la plateforme du jeu concours ou par n’importe quel moyen de communication.\n\n'),
                  TextSpan(
                    text: 'ARTICLE 13 : COMPETENCE JURIDICTIONNELLE \n\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                      text:
                          '  Les Participants admettent sans réserve que le simple fait de participer à ce jeu concours les soumet obligatoirement aux lois marocaines notamment pour tout litige qui viendrait à naître du fait du jeu concours objet des présentes ou qui serait directement ou indirectement lié à celui-ci.\n\n'
                          '  Tout litige entre les parties, et à défaut d’accord amiable, relève de la compétence exclusive du tribunal de Commerce de Casablanca.\n\n'),
                  TextSpan(
                    text: 'ARTICLE 14 : NULLITE PARTIELLE  \n\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                      text:
                          '  Il est expressément convenu, qu’au cas où l’une des stipulations contenues dans le présent règlement seraient jugées nulles ou inapplicables pour quelque raison que ce soit, toute autre stipulation des présentes n’en serait aucunement affectée ou altérée et la validité ou l’exécution de la ou des stipulations concernées ne serait pas remise en cause dans toute autre situation ou devant toute autre juridiction.\n\n'),
                  TextSpan(
                      text: 'Fait à Casablanca, le 10 Septembre 2024.\n\n'),
                  TextSpan(
                    text: 'La société « Bourchanin et Cie »\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'M. HICHAM RKHA\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
