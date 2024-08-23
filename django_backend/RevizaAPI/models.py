from django.db import models
import os
import uuid
from django.utils.translation import gettext_lazy as _

class University(models.Model):
    name = models.CharField(max_length=255)

    def __str__(self):
        return self.name

class Faculty(models.Model):
    university = models.ForeignKey(University, related_name='faculties', on_delete=models.CASCADE)
    name = models.CharField(max_length=255)

    def __str__(self):
        return self.name

class Program(models.Model):
    faculty = models.ForeignKey(Faculty, related_name='programs', on_delete=models.CASCADE)
    name = models.CharField(max_length=255)

    def __str__(self):
        return self.name

class Year(models.Model):
    program = models.ForeignKey(Program, related_name='years', on_delete=models.CASCADE)
    year_number = models.PositiveIntegerField()

    def __str__(self):
        return f"Year {self.year_number} - {self.program.name}"
    
class Course(models.Model):
    year = models.ForeignKey(Year, related_name='courses', on_delete=models.CASCADE)
    course = models.CharField(max_length=255)

    def __str__(self):
        return f"Course:: {self.course}"



class StudyMaterial(models.Model):
    class MaterialType(models.TextChoices):
        NOTES = 'NOTES', _('Notes')
        PAPERS = 'PAPERS', _('Papers')
        BOOKS = 'BOOKS', _('Books')
        LINKS = 'LINKS', _('Links')
        ASSIGNMENT = 'ASSIGNMENT', _('Assignment')
        LAB = 'LAB', _('Lab')

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)  # Automatically generated unique ID
    type = models.CharField(max_length=20, choices=MaterialType.choices)
    course = models.ForeignKey(Course, related_name='courses', on_delete=models.CASCADE)
    title = models.CharField(max_length=255)
    description = models.TextField()

    # FileField for storing file uploads
    file = models.FileField(upload_to='study_materials/', null=True, blank=True)

    size = models.CharField(max_length=50, null=True, blank=True, editable=False)

    fans = models.JSONField(default=list)
    haters = models.JSONField(default=list)
    reports = models.JSONField(default=list)

    uploaded_at = models.DateTimeField(auto_now_add=True, null=True, editable=False)  # Automatically records the upload date

    def __str__(self):
        return f"{self.title} ({self.subject_name})"
    
    def save(self, *args, **kwargs):
        # Automatically calculate the size of the file
        if self.file:
            self.size = self.get_file_size(self.file.size)
        super().save(*args, **kwargs)
    
    def get_file_size(self, size_in_bytes):
        if size_in_bytes < 1024:
            return f"{size_in_bytes} bytes"
        elif size_in_bytes < 1024 * 1024:
            return f"{size_in_bytes / 1024:.2f} KB"
        elif size_in_bytes < 1024 * 1024 * 1024:
            return f"{size_in_bytes / (1024 * 1024):.2f} MB"
        else:
            return f"{size_in_bytes / (1024 * 1024 * 1024):.2f} GB"
