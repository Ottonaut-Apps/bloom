# Bloom

Eine App die Schuler, Studierende und Lernende dabei zu unterstützen, sich besser auf das Lernen 
selbst zu konzentrieren und Ablenkungen durch zum Beispiel Social Media zu vermeiden.

## App-Nutzung

Einstellungen: Ermöglicht das regelmäßige Senden von Nachrichten.
Fokussieren: Hauptbestandteil der App. Timer der abläuft, in dieser Zeit soll sich der Nutzer nicht
ablenken lassen.
Flash Cards: Karteikarten sollen erstellt und abgespeichert werden. Funktionalität unvollständig
Meine Statistik: Statistik für den Nutzer damit dieser betrachten kann, welche "Erfolge" er erreicht
hat. Allerdings werden derzeitig nur Mock-Daten dargestellt.

## Probleme
- Kein Persistentes Speichern
- Als ich die Abgabe machen wollte funktionierte die App plötzlich nicht mehr, da das Notification-Plugin vermutlich ein Update und damit eine Veränderung des Source Codes hatte. Da ich zuvor die Version nicht gepinnt habe kann ich nicht nachvollziehen was sich geändert hat. Wenn Nachrichten entfernt werden, wird die Funktionalität der App wieder hergestellt.

## Lessons Learned
- Zusammenarbeit mit Fachleuten fördert die Findung von Ideen
- die Priorisierung der Aufgaben fällt durch mehrere Stimmen oft anders
- Kritik ist besser als keine Kritik (schweigen; alles gut finden)
- Shared Preferences hätte es ermöglicht schneller eine Datenbankanbindung zu schaffen
- Viele Bestandteile können aus alten App übernommen werden, wodurch schneller eine vollwertige App zustande kommt
- Die Formattierung einer neuen App sollte von vornerein responsiv ablaufen und nicht mit festen Bestandteilen (z.B. Sizedbox) erstellt werden
- Die Aufteilung der Ordner sollte bei der nächsten App lieber der Standardordnerstruktur entsprechen (view, util...)
- Nachrichten können recht leicht lokal gesendet werden
- Herausgefunden wie das App-Icon geändert werden kann (Arbeit mit AndroidManifest)
- Herausgefunden wie ein ProgressCircle genutzt werden kann und an die Zeit angepasst wird (AnimationsController)
- Der Timer läuft bei Standby-Screen nicht - Apps werden standardmäßig nach ca. 3min gestoppt
- Plugins sollten version-pinned sein, sonst wacht man eines Tages auf und die App funktioniert auf magische Weise gar nicht mehr ohne das man den Fehler nach Stunden finden kann :)

