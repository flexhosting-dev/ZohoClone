<?php

namespace App\Command;

use App\Repository\ProjectRepository;
use App\Repository\UserRepository;
use App\Service\PersonalProjectService;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;

#[AsCommand(
    name: 'app:create-personal-projects',
    description: 'Create personal projects for existing users who do not have one',
)]
class CreatePersonalProjectsCommand extends Command
{
    public function __construct(
        private readonly UserRepository $userRepository,
        private readonly ProjectRepository $projectRepository,
        private readonly PersonalProjectService $personalProjectService,
        private readonly EntityManagerInterface $entityManager,
    ) {
        parent::__construct();
    }

    protected function configure(): void
    {
        $this->addOption('dry-run', null, InputOption::VALUE_NONE, 'Run without making changes');
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = new SymfonyStyle($input, $output);
        $dryRun = $input->getOption('dry-run');

        if ($dryRun) {
            $io->note('Running in dry-run mode. No changes will be made.');
        }

        $users = $this->userRepository->findAll();
        $created = 0;
        $skipped = 0;

        foreach ($users as $user) {
            $existingProject = $this->projectRepository->findPersonalProjectForUser($user);

            if ($existingProject) {
                $skipped++;
                $io->text(sprintf('Skipping %s - already has personal project', $user->getEmail()));
                continue;
            }

            if ($dryRun) {
                $io->text(sprintf('Would create personal project for %s', $user->getEmail()));
                $created++;
                continue;
            }

            $project = $this->personalProjectService->createPersonalProject($user);
            $created++;
            $io->text(sprintf('Created "%s" for %s', $project->getName(), $user->getEmail()));
        }

        if (!$dryRun) {
            $this->entityManager->flush();
        }

        $io->success(sprintf(
            '%s %d personal projects. Skipped %d users who already had one.',
            $dryRun ? 'Would create' : 'Created',
            $created,
            $skipped
        ));

        return Command::SUCCESS;
    }
}
