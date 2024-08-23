from django.db import models
import os
import uuid

class StudyMaterial(models.Model):
    TYPE_CHOICES = [
        ('NOTE', 'Note'),
        ('BOOK', 'Book'),
        ('VIDEO', 'Video'),
        # Add more types as needed
    ]

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)  # Automatically generated unique ID
    type = models.CharField(max_length=50, choices=TYPE_CHOICES)
    subject_name = models.CharField(max_length=255)
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
