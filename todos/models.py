from django.db import models
from django.utils import timezone

class Todo(models.Model):
    STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('resolved', 'Resolved'),
    ]
    
    title = models.CharField(max_length=200)
    description = models.TextField(blank=True)
    due_date = models.DateField(null=True, blank=True)
    status = models.CharField(max_length=10, choices=STATUS_CHOICES, default='pending')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-created_at']
        db_table = 'TODO_todo'
    
    def __str__(self):
        return self.title
    
    def is_overdue(self):
        if self.due_date and self.status == 'pending':
            return self.due_date < timezone.now().date()
        return False
