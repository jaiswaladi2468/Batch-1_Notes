```yaml

---
- name: webserver configuration
  hosts: webservers
  become: yes
  tasks:
    - name: update package cache 
      apt:
        update_cache: yes 

    
    - name: Install Apache
      apt:
        name: apache2
        state: present

    - name: Install Maven
      apt:
        name: maven
        state: present

- name: Database server configuration
  hosts: dbservers
  become: yes 
  tasks:
    - name: install postgressql
      apt:
        name: postgresql 
        state: present

```
