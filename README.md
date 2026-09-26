# Chrono Coach

Application Flutter de **chrono d’entraînement par intervalles**.

Tu prépares ta séance (nombre d’efforts, durées, pauses), tu lances le chrono, et l’app enchaîne automatiquement les étapes avec un compte à rebours visuel et des bips sonores.

Le dépôt s’appelle `chronosport` ; le nom affiché dans l’app est **Chrono Coach**.

---

## À quoi ça sert

Chrono Coach remplace le chronomètre + la calculatrice mentale pendant un entraînement :

1. **Préparer** — choisir un format prêt à l’emploi ou régler les 4 paramètres.
2. **Vérifier** — voir le programme et la durée totale avant de partir.
3. **Enchaîner** — le chrono passe tout seul d’une séance à une pause, jusqu’à la grande pause.

Idéal pour Tabata, HIIT, rounds de boxe ou fractionné.

---

## Fonctionnalités

- **4 réglages** : nombre de séances, durée d’effort, pause courte, grande pause
- **Presets** : Tabata, HIIT, Boxe, Fractionné (modifiables ensuite)
- **Aperçu** du programme et du temps total
- **Anneau de compte à rebours** coloré selon le type d’étape
- **Timeline** : étape en cours, suivantes, déjà terminées
- **Pause / reprise** pendant la séance
- **Sons** : bip les 5 dernières secondes, bip final au changement d’étape
- **Thème** clair, sombre ou système
- **Dernière config mémorisée** (rechargée au prochain lancement)
- **Mise en page adaptative** téléphone / tablette / web

### Couleurs des étapes

| Étape         | Rôle              | Couleur   |
|---------------|-------------------|-----------|
| Séance        | Effort            | Vert lime |
| Pause         | Récupération      | Orange    |
| Grande pause  | Repos de fin      | Bleu      |

### Presets inclus

| Preset      | Séances | Effort | Pause | Grande pause |
|-------------|---------|--------|-------|--------------|
| Tabata      | 8       | 20 s   | 10 s  | 60 s         |
| HIIT        | 10      | 40 s   | 20 s  | 90 s         |
| Boxe        | 6       | 3 min  | 1 min | 2 min        |
| Fractionné  | 12      | 1 min  | 30 s  | 3 min        |

---

## Stack

- Flutter / Dart (SDK `^3.7.0`)
- [audioplayers](https://pub.dev/packages/audioplayers) pour les bips
- Material 3, thèmes clair et sombre
- Cibles : Android, iOS, Web, Windows, macOS, Linux

---

## Structure du code

```
lib/
  main.dart                 Point d’entrée
  chrono_app.dart           App + thème
  models/                   Config, presets, étapes
  controllers/              Logique du chrono (sans UI)
  views/                    Écrans setup et séance
  widgets/                  Composants d’interface
  services/                 Sauvegarde de la dernière config
  theme/                    Couleurs et thème
  utils/                    Formatage des durées
assets/
  sounds/                   beep.mp3, final_beep.mp3
  splash/                   Écran de lancement
```

La logique du chrono vit dans `SessionController` : elle est séparée des widgets pour rester simple à tester.

---

## Prérequis

- [Flutter](https://docs.flutter.dev/get-started/install) 3.7 ou plus récent
- Un appareil, un émulateur, ou `chrome` / `windows` / `macos` / `linux`

Vérifier l’installation :

```bash
flutter doctor
```

---

## Lancer le projet

```bash
git clone https://github.com/AmineIkhedji/chronosport.git
cd chronosport
flutter pub get
flutter run
```

Cible précise :

```bash
flutter run -d chrome
flutter run -d windows
flutter run -d android
```

---

## Commandes utiles

```bash
flutter analyze          # Analyse statique
flutter test             # Tests
flutter build apk        # APK Android
flutter build web        # Build web
```

Splash et icônes (après modification de `assets/splash/splash.png`) :

```bash
dart run flutter_native_splash:create
dart run flutter_launcher_icons
```

---

## Licence

Distribué sous licence [MIT](LICENSE).
