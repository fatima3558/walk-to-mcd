# Generated by Django 3.2.2 on 2021-06-03 22:14

import django.contrib.gis.db.models.fields
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Location',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('point', django.contrib.gis.db.models.fields.PointField(srid=4326)),
                ('name', models.CharField(max_length=15)),
            ],
        ),
    ]