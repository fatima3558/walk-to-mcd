from django.db import models
from django.contrib.gis.db import models as geo_models


class Location(models.Model):
    point = geo_models.PointField()
    name = models.CharField(max_length=15)
