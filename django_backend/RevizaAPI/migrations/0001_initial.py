# Generated by Django 5.1 on 2024-08-25 12:16

import django.db.models.deletion
import uuid
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Course',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=255, unique=True)),
            ],
        ),
        migrations.CreateModel(
            name='Faculty',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=255)),
            ],
        ),
        migrations.CreateModel(
            name='University',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=255)),
            ],
        ),
        migrations.CreateModel(
            name='Program',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=255)),
                ('faculty', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='programs', to='RevizaAPI.faculty')),
            ],
        ),
        migrations.CreateModel(
            name='Student',
            fields=[
                ('name', models.CharField(max_length=255, primary_key=True, serialize=False, unique=True)),
                ('course_name', models.JSONField(default=list, null=True)),
                ('courses', models.ManyToManyField(related_name='students', to='RevizaAPI.course')),
            ],
        ),
        migrations.CreateModel(
            name='StudyMaterial',
            fields=[
                ('id', models.UUIDField(default=uuid.uuid4, editable=False, primary_key=True, serialize=False)),
                ('type', models.CharField(choices=[('NOTES', 'Notes'), ('PAPERS', 'Papers'), ('BOOKS', 'Books'), ('LINKS', 'Links'), ('ASSIGNMENT', 'Assignment'), ('LAB', 'Lab')], max_length=20)),
                ('course_name', models.CharField(editable=False, max_length=255)),
                ('title', models.CharField(max_length=255)),
                ('description', models.TextField()),
                ('file', models.FileField(blank=True, null=True, upload_to='study_materials/')),
                ('size', models.CharField(blank=True, editable=False, max_length=50, null=True)),
                ('uploaded_at', models.DateTimeField(auto_now_add=True, null=True)),
                ('course', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='study_materials', to='RevizaAPI.course')),
                ('fans', models.ManyToManyField(blank=True, related_name='liked_materials', to='RevizaAPI.student')),
                ('haters', models.ManyToManyField(blank=True, related_name='disliked_materials', to='RevizaAPI.student')),
                ('reports', models.ManyToManyField(blank=True, related_name='reported_materials', to='RevizaAPI.student')),
            ],
        ),
        migrations.AddField(
            model_name='faculty',
            name='university',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='faculties', to='RevizaAPI.university'),
        ),
        migrations.CreateModel(
            name='Year',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('year_number', models.PositiveIntegerField()),
                ('program', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='years', to='RevizaAPI.program')),
            ],
        ),
        migrations.AddField(
            model_name='course',
            name='year',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='courses', to='RevizaAPI.year'),
        ),
    ]
