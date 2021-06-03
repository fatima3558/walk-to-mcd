django.conf import settings
django.core.management.base import CoreCommand, BaseCommand


class Command(BaseCommand):
    """Load locations from selected geojson files into PostGIS database."""
    help = 'Load locations into PostGIS database.'

    def handle(self, *args, **kwargs):
        
        return