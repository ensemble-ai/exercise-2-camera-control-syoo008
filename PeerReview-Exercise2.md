# Peer-Review for Programming Exercise 2

## Description

For this assignment, you will be giving feedback on the completeness of assignment two: Obscura. To do so, we will give you a rubric to provide feedback. Please give positive criticism and suggestions on how to fix segments of code.

You only need to review code modified or created by the student you are reviewing. You do not have to check the code and project files that the instructor gave out.

Abusive or hateful language or comments will not be tolerated and will result in a grade penalty or be considered a breach of the UC Davis Code of Academic Conduct.

If there are any questions at any point, please email the TA.

## Due Date and Submission Information

See the official course schedule for due date.

A successful submission should consist of a copy of this markdown document template that is modified with your peer review. This review document should be placed into the base folder of the repo you are reviewing in the master branch. The file name should be the same as in the template: `CodeReview-Exercise2.md`. You must also include your name and email address in the `Peer-reviewer Information` section below.

If you are in a rare situation where two peer-reviewers are on a single repository, append your UC Davis user name before the extension of your review file. An example: `CodeReview-Exercise2-username.md`. Both reviewers should submit their reviews in the master branch.

# Solution Assessment

## Peer-reviewer Information

- _name:_ Leo Ying
- _email:_ leoying@ucdavis.edu

### Description

For assessing the solution, you will be choosing ONE choice from: unsatisfactory, satisfactory, good, great, or perfect.

The break down of each of these labels for the solution assessment.

#### Perfect

    Can't find any flaws with the prompt. Perfectly satisfied all stage objectives.

#### Great

    Minor flaws in one or two objectives.

#### Good

    Major flaw and some minor flaws.

#### Satisfactory

    Couple of major flaws. Heading towards solution, however did not fully realize solution.

#### Unsatisfactory

    Partial work, not converging to a solution. Pervasive Major flaws. Objective largely unmet.

---

## Solution Assessment

### Stage 1

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

---

#### Justification

Camera is locked onto target as intended. Note that draw_camera_logic is not initalized to true but this is not exclusive to this stage alone (problem is universal to all stages).

---

### Stage 2

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

---

#### Justification

The target moves in relation to the box, which I believe is incorrect. Instead, the box should eventually catchup to the immobile target and push it along its left edge (assuming there is no player input).

---

### Stage 3

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

---

#### Justification

Lots of jittering when moving diagonally. Otherwise it seems to function as intended.

---

### Stage 4

- [ ] Perfect
- [ ] Great
- [ ] Good
- [x] Satisfactory
- [ ] Unsatisfactory

---

#### Justification

Although the catchup function is implemented correctly, there seem to be some issues with camera positioning when moving through more than two inputs/directions. Additionally, the camera-target dynamic is incorrect when in hyperspeed (the camera is behind the target rather than the other way around).

---

### Stage 5

- [ ] Perfect
- [ ] Great
- [x] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

---

#### Justification

The speed-up zone is good but the drawn outer pushbox is larger than the actual pushbox, creating a visual disconnect. Furthermore, the functionality is implemented incorrectly in regards to diagonal movement.

---

# Code Style

### Description

Check the scripts to see if the student code adheres to the GDScript style guide.

If sections do not adhere to the style guide, please peramlink the line of code from Github and justify why the line of code has not followed the style guide.

It should look something like this:

- [description of infraction](https://github.com/dr-jam/ECS189L) - this is the justification.

Please refer to the first code review template on how to do a permalink.

#### Style Guide Infractions

- Code styling appears consistent with no glaring issues.

#### Style Guide Exemplars

- All variables are correctly typed with static types, using snake_case for naming consistency.

- Class names are in PascalCase, adhering to convention, and are relevant to their function.

- For the most part, student utilizes concise [comments](https://github.com/ensemble-ai/exercise-2-camera-control-syoo008/blob/546deb9b1b46e27b319de3bfb7b91a03c9ce5743/Obscura/scripts/camera_controllers/position_lock.gd#L19) to effectively describe each code section’s purpose.

- File structure aligns with the style guide: class declarations and inheritances are at the top, with variables and exports properly placed in designated sections.

---

#### Put style guide infractures

---

# Best Practices

### Description

If the student has followed best practices then feel free to point at these code segments as examplars.

If the student has breached the best practices and has done something that should be noted, please add the infraction.

This should be similar to the Code Style justification.

#### Best Practices Infractions

- Student should delete unused/unecessary [comments](https://github.com/ensemble-ai/exercise-2-camera-control-syoo008/blob/546deb9b1b46e27b319de3bfb7b91a03c9ce5743/Obscura/scripts/camera_controllers/position_lock_lerp_smooth.gd#L53) and [debugging](https://github.com/ensemble-ai/exercise-2-camera-control-syoo008/blob/546deb9b1b46e27b319de3bfb7b91a03c9ce5743/Obscura/scripts/camera_controllers/auto_scroll.gd#L33) statements.

- In the draw_logic() function for four_way_speedup.gd, student could create a helper function to reduce code density for [reusable](https://github.com/ensemble-ai/exercise-2-camera-control-syoo008/blob/546deb9b1b46e27b319de3bfb7b91a03c9ce5743/Obscura/scripts/camera_controllers/four_way_speedup.gd#L87) components.

- draw_camera_logic should be initialized to true within camera_selector.gd

#### Best Practices Exemplars

- Variables are defined with relevant and easy-to-understand names.

- Overall, the code is structured in a clear, comprehensible manner that accurately reflects the functionality of each class.
