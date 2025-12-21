import { tool } from "@opencode-ai/plugin"

export default tool({
  description: "Collect and display metadata about the current environment including date/time, git repository info, and optional thoughts status",
  args: {},
  async execute(args, context) {
    const metadata = {}
    
    // Date/time metadata
    const now = new Date()
    metadata.datetime_tz = now.toLocaleString('en-US', { 
      timeZoneName: 'short',
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit'
    })
    
    metadata.filename_ts = now.toISOString().replace(/[:.]/g, '-').slice(0, 19).replace('T', '_')
    
    // Git repository metadata
    try {
      const gitRoot = await Bun.$`git rev-parse --show-toplevel`.text().catch(() => '')
      if (gitRoot.trim()) {
        const repoRoot = gitRoot.trim()
        metadata.repo_name = repoRoot.split('/').pop() || ''
        
        const branch = await Bun.$`git branch --show-current`.text().catch(() => '')
        metadata.git_branch = branch.trim() || (await Bun.$`git rev-parse --abbrev-ref HEAD`.text().catch(() => '')).trim()
        
        const commit = await Bun.$`git rev-parse HEAD`.text().catch(() => '')
        metadata.git_commit = commit.trim()
      }
    } catch (error) {
      // Not in a git repository or git not available
      metadata.repo_name = ''
      metadata.git_branch = ''
      metadata.git_commit = ''
    }
    
    // Optional: thoughts system status
    try {
      const thoughtsStatus = await Bun.$`humanlayer thoughts status`.text().catch(() => '')
      if (thoughtsStatus.trim()) {
        metadata.thoughts_status = thoughtsStatus.trim().split('\n').slice(0, 40).join('\n')
      }
    } catch (error) {
      // humanlayer not available or failed
      metadata.thoughts_status = ''
    }
    
    // Format output similar to the bash script
    let output = `Current Date/Time (TZ): ${metadata.datetime_tz}\n`
    if (metadata.git_commit) {
      output += `Current Git Commit Hash: ${metadata.git_commit}\n`
    }
    if (metadata.git_branch) {
      output += `Current Branch Name: ${metadata.git_branch}\n`
    }
    if (metadata.repo_name) {
      output += `Repository Name: ${metadata.repo_name}\n`
    }
    output += `Timestamp For Filename: ${metadata.filename_ts}\n`
    if (metadata.thoughts_status) {
      output += `${metadata.thoughts_status}\n`
    }
    
    return output.trim()
  }
})