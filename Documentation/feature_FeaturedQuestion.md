# **Featured (featured) question feature**
## **(BDD) Show Featured Question Spec**
### Story: Client requests to see featured random question

### Narrative #1

```
As an online customer
I want the app to automatically load featured (featured) question
```

#### Scenarios (Acceptance criteria)

``` 
Given the customer has connectivity
And the customer did not load featured question today
 When the customer requests featured question
 Then the app should display the featured question
  And store featured question in cache

Given the customer has connectivity
And the client did load featured question today
 When the client requests featured question
 Then the app should display the featured question from cache
```

### Narrative #2

```
As an offline customer
I want the app to show the latest saved version of the featured question
```

#### Scenarios (Acceptance criteria)

```
Given the customer doesn't have connectivity
  And there’s a cached version of the featured question
  And the cache is less than seven days old
 When the customer requests to see the featured question
 Then the app should display the latest cached featured question

Given the customer doesn't have connectivity
  And there’s a cached version of the featured question
  And the cache is seven days old or more
 When the customer requests to see the featured question
 Then the app should display an error message

Given the customer doesn't have connectivity
  And the cache is empty
 When the customer requests to see the featured question
 Then the app should display an error message
```
---
## **Use Cases**

### Load featured Question From Remote Use Case

#### Data:
- URL
- parameters:
 - timezone: TZ database name (like: US/Eastern)

#### Primary course (happy path):
1. Execute "Load featured Question" command with above data.
2. System downloads data from the URL.
3. System validates downloaded data.
4. System creates question from valid data.
5. System delivers question.

#### Invalid data – error course (sad path):
1. System delivers invalid data error.

#### No connectivity – error course (sad path):
1. System delivers connectivity error.

---

### Load News featured Question From Cache Use Case

#### Primary course:
1. Execute "Load featured Question" command with above data.
2. System retrieves featured question data from cache.
3. System validates cache is less than seven days old.
4. System creates featured question from cached data.
5. System delivers featured question.

#### Retrieval error course (sad path):
1. System delivers error.

#### Expired cache course (sad path): 
1. System delivers no featured question.

#### Empty cache course (sad path): 
1. System delivers no featured question.

---

### Validate featured Question Cache Use Case

#### Primary course:
1. Execute "Validate Cache" command with above data.
2. System retrieves featured question data from cache.
3. System validates cache is less than seven days old.

#### Retrieval error course (sad path):
1. System deletes cache.

#### Expired cache course (sad path): 
1. System deletes cache.

---

### Cache featured Question Data Use Case

#### Data:
- featured Question Data

#### Primary course (happy path):
1. Execute "featured Question Data" command with above data.
2. System caches news data.
3. System delivers success message.

#### Saving error course (sad path):
1. System delivers error.

---

## Model Specs


### Question Model

| Property      | Type                     |
|---------------|--------------------------|
| `id`          | `Int`                    |
| `question`    | `String`			       |
| `answer`      | `String`			       |
| `difficulty`  | `String`	(valid only: `easy`, `medium`, `advanced`) |
| `source`      | `String (optional)`	   |
| `attachments` | `Array<AnswerAttachment Model (text or image)>` |
| `categories`  | `Array<Category Model>`|

### AnswerAttachment Model

#### AnswerAttachment Model - type: text
| Property      | Type                |
|---------------|---------------------|
| `type`        | `text: String`      |
| `content`     | `String`            |

#### AnswerAttachment Model - type: image
| Property      | Type                |
|---------------|---------------------|
| `type`        | `image: String`     |
| `link`        | `URL`               |

### Category Model

| Property         | Type                   |
|------------------|------------------------|
| `id`             | `Int`                  |
| `title`          | `String`			    |

### Payload contract

```
GET /featured-question

200 RESPONSE

{
  "id": 1,

  "question": "How to silence compiler warning about unused return value from a function?",

  "answer": "Apply @discardableResult attribute to a function or method declaration to suppress the compiler warning when the function or method that returns a value is called without using its result",

  "difficulty": "easy",

  "source": "<a href=\"https://docs.swift.org/swift-book/ReferenceManual/Attributes.html\">Swift - Attributes</a>",

  "categories": [
    {
      "id": 1,
      "title": "Swift"
    },
    {
      "id": 2,
      "title": "Attributes"
    }
  ],

  "attachments": [
    {
      "type": "text",
      "content": "With <strong>@discardableResult</strong> attribute, the compiler won't show a warning about the unused return value"
    },
    {
      "type": "image",
      "link": "https://alexalmostengineer.co.ua/wp-content/uploads/2021/03/Screenshot-2021-03-02-at-17.30.18.png"
    },
	...
  ]
}
```
---